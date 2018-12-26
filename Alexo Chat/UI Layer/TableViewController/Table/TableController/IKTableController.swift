//
//  IKTableController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import Foundation

// MARK: - All business logic in IKTableController, IKtableController+Filter, IKTableController+DataSource
// MARK: - UIViewController
class IKTableController: UIViewController {

    // MARK: - Properties
    private var configuration: IKTableConfiguration!
    private var contentOffsetObservation: NSKeyValueObservation?
    private var contentState: IKTableContentState = .success
    private var processState: IKTableProcessState = .stopped
    private var searchBarView: UIView! = nil
    var toolbarView: IKTableToToolbarProtocol?

    // MARK: - Properties views
    var refreshControl: UIRefreshControl! = nil
    var footerView: IKBaseContainerFooterView! = nil
    var toolbar: UIToolbar?
    var searchBar: UISearchBar? {
        didSet {
            self.searchBar?.delegate = self.delegateSearch
        }
    }

    // MARK: - Properties to get views
    weak var viewProtocol: IKTableToViewControllerProtocol?

    weak var delegateSearch: UISearchBarDelegate? {
        didSet {
            self.searchBar?.delegate = self.delegateSearch
        }
    }
    // MARK: - Custom setters
    weak var delegateDataSource: IKTableControllerDelegate? {
        didSet {
            self.tableView?.delegate = self.delegateDataSource
            self.tableView?.dataSource = self.delegateDataSource
        }
    }
    var tableView: UITableView! {
        didSet {
            self.tableView?.delegate = self.delegateDataSource
            self.tableView?.dataSource = self.delegateDataSource
        }
    }

    // MARK: - Default init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Custom init
    init(configuration: IKTableConfiguration) {

        super.init(nibName: nil, bundle: nil)
        guard let copy = configuration.copy() as? IKTableConfiguration else { return }
        self.configuration = copy
    }

    // MARK: - Create UI and fetch first page if possible
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().tableBackground
        self.extendedLayoutIncludesOpaqueBars = true
        self.createUI()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createContentObserver()
    }

    // MARK: - Убираем обсервер на скроллинг вниз таблицы
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.contentOffsetObservation != nil {
            self.contentOffsetObservation?.invalidate()
            self.contentOffsetObservation = nil
        }
    }
}

// MARK: - Private methods
extension IKTableController {

    // MARK: - TableFooter
    private func setTableFooterAndRefresh(enableRefresh: Bool, contentState: IKTableFooterType) {
        DispatchQueue.main.async {
            if self.footerView != nil {
                self.footerView.displayState(contentState)
            }
            enableRefresh ? self.enableRefreshControl() : self.disableRefreshControl()
        }
    }
}

// MARK: - Table to Parent VC
extension IKTableController {
    // MARK: - PullToRefreshAction
    @objc private func pullToRefreshAction(_ refreshControl: UIRefreshControl) {
        //Если уже идет какая-то загрузка ничего не делается
        if self.processState != .loading {
            self.processState = .loading
            self.delegateDataSource?.pullToRefresh(tableController: self)
        }
    }

    // MARK: - FetchNextAction
    private func fetchNextPageAction() {
        //Если уже идет какая-то загрузка ничего не делается
        if self.processState != .loading && self.contentState != .endFetching {
            self.processState = .loading

            //Если успешно прогрузили предыдущую страницу показываем лоадер следующей страницы
            if self.contentState == .success {
                if self.footerView != nil {
                    self.footerView.displayState(.loader)
                }
            }

            //Блочим рефреш контрол на время загрузки след. страницы, что бы не было кучи загрузок
            self.disableRefreshControl()
            self.delegateDataSource?.fetchNextPage(tableController: self)
        }
    }
}

// MARK: - Останавливаем все загрузки, отображаем по статусу вьюшки
extension IKTableController {

    func dequeueCell<T: UITableViewCell>(indexPath: IndexPath) -> T {

        let reuseIdentifier = T.getIdentifier()
        guard let t = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("cant use this method")
        }
        return t
    }

    func dequeueCell(type: UITableViewCellIdentifierProvider.Type, indexPath: IndexPath) -> UITableViewCell {

        let reuseIdentifier = type.getIdentifier()
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }

    func startLoading() {
        self.fetchNextPageAction()
    }

    func stopLoading(state: IKTableContentState) {

        //Останавливаем загрузку во вьюшках, если она где-то есть
        self.stopLoadingView()
        self.contentState = state

        switch self.contentState {

            //Если успешно загрузилось или постраничная загрузка вся пройдена, показываем пустой футер
        case .success, .endFetching:
            self.setTableFooterAndRefresh(enableRefresh: true, contentState: .empty)

            //Пришел пустой список данных
        case .noContent:
            self.setTableFooterAndRefresh(enableRefresh: false, contentState: .noContent)

            //Пришла ошибка на загрузку данных
        case .failedLoaded:
            self.setTableFooterAndRefresh(enableRefresh: false, contentState: .error)

            //Пришла ошибка на загрузку след странцы данных
        case .failedNextPageLoaded:
            self.setTableFooterAndRefresh(enableRefresh: true, contentState: .nextPageError)
            self.tableView.scrollRectToVisible((self.tableView.tableFooterView?.frame)!, animated: true)
        }

        //Останавливается процесс загрузки, после обновления всех вьюшек и тд, загрузка следующей страницы, если первая страница занимает часть экрана
        self.processState = .stopped
        DispatchQueue.main.async {
            if self.tableContentDifference() < 0 && self.contentState == .success && self.processState == .stopped && self.configuration.tableOptions.contains(.paged) {
                self.fetchNextPageAction()
            }
        }
    }
}

// MARK: - Create UI
extension IKTableController {

    //Create UI
    private func createUI() {
        self.createSearchBar()
        self.createToolBar()
        self.createTableView()
        self.createFooterViews()

        self.enableRefreshControl()
    }

    //SearchBar
    private func createSearchBar() {
        if self.configuration.tableOptions.contains(.searchBar) {
            if let tuple = self.viewProtocol?.getSearchBarView() {

                self.searchBar = tuple.searchBar
                self.searchBarView = tuple.viewForLayout
                self.view.addSubview(self.searchBarView)

                self.searchBarView.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.left.equalToSuperview()
                    $0.right.equalToSuperview()
                    $0.height.greaterThanOrEqualTo(44)
                }
            }
        }
    }

    //ToolBar
    private func createToolBar() {
        if self.configuration.tableOptions.contains(.toolBar) {
            if let tuple = self.viewProtocol?.getToolbarView(), let viewForLayout = tuple.viewForLayout as? UIView {

                self.toolbar = tuple.toolbar
                self.toolbarView = tuple.viewForLayout

                self.view.addSubview(viewForLayout)
                viewForLayout.snp.makeConstraints {
                    $0.bottom.equalToSuperview()
                    $0.left.equalToSuperview()
                    $0.right.equalToSuperview()
                    $0.height.greaterThanOrEqualTo(44)
                }
            }
        }
    }

    //Table and cells
    private func createTableView() {
        self.tableView = UITableView()
        self.tableView.tableFooterView = UIView()
        self.edgesForExtendedLayout = .all
        self.tableView.contentInsetAdjustmentBehavior = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
//        self.tableView.contentInsetAdjustmentBehavior = .never

        self.view.addSubview(self.tableView)

        self.configuration.cellClasses.forEach { cellClass in

            guard let casted = cellClass.self as? UITableViewCell.Type else {

                return
            }
            let reuseIdentifier = casted.getIdentifier()
            self.tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
        }

        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.searchBarView == nil ? self.view : self.searchBarView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            if let toolbarView = self.toolbarView as? UIView {

                $0.bottom.equalTo(toolbarView.snp.top)
            } else {

                $0.bottom.equalTo(self.view)
            }
        }
    }

    //Table footer view
    private func createFooterViews() {
        if let footerView = self.viewProtocol?.getFooterView() {
            footerView.delegate = self
            self.footerView = footerView
        }
    }
}

// MARK: - Filter to Table
extension IKTableController: IKFilterToTable {
    func didClickFilterNotificationClose() {
        self.toolbarView?.hideOverview(animation: true)

        self.delegateDataSource?.closeFilter(tableController: self, completion: { (flag) in
            if flag == true {
                self.contentState = .success
                if self.footerView != nil {
                    self.footerView.displayState(.loader)
                }
                self.fetchNextPageAction()
            }
        })
    }
}

// MARK: - Table to FooterErrorViews
extension IKTableController {
    private func startLoadingView() {
        if self.footerView != nil {
            self.footerView.displayActivity(true)
        }
    }

    private func stopLoadingView() {
        if self.refreshControl != nil {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }

        if self.footerView != nil {
            self.footerView.displayActivity(false)
        }
    }
}

// MARK: - FooterErrorViews to Table
extension IKTableController: IKViewToTableProtocol {
    func footerViewDidChangeFrame(_ view: IKBaseFooterView) {
        self.tableView.tableFooterView = view
    }

    func fetchNextPageFromView(_ view: IKBaseFooterView) {

        self.fetchNextPageAction()
    }
}

// MARK: - Fetch next page when scrolling
extension IKTableController {
    private func createContentObserver() {
        if self.configuration.tableOptions.contains(.paged) && self.contentOffsetObservation == nil {

            self.contentOffsetObservation = self.tableView.observe(\.contentOffset, options: [.new], changeHandler: { (_, change) in

                    //Если не идет никакая загрузка, и удалось загрузить предыдущую страницу, загружаем следующую и пролистнули до низу -- пытаемся загрузить следю страницу
                    if let offset = change.newValue?.y {
                        DispatchQueue.main.async {
                            let flag = (offset > self.tableContentDifference()) ? true : false

                            if flag && self.contentState == .success && self.processState == .stopped {
                                self.fetchNextPageAction()
                            }
                        }
                    }
                })
        }
    }

    private func tableContentDifference() -> CGFloat {
        let contentSize = self.tableView.contentSize.height
        let frameSize = self.tableView.frame.size.height
        let difference = contentSize - frameSize

        return difference
    }
}

// MARK: - Refresh control
extension IKTableController {
    private func enableRefreshControl() {
        if self.configuration.tableOptions.contains(.refreshControl) {
            DispatchQueue.main.async {
                if self.refreshControl == nil {
                    self.refreshControl = UIRefreshControl()
                    self.refreshControl.addTarget(self, action: #selector(IKTableController.pullToRefreshAction(_:)), for: UIControl.Event.valueChanged)
                    self.refreshControl.tintColor = ThemeManager.currentTheme().tableBackground
                }
                self.tableView.refreshControl = self.refreshControl
            }
        }
    }

    private func disableRefreshControl() {
        DispatchQueue.main.async {
            self.tableView.refreshControl = nil
        }
    }
}

// MARK: - IKDataSourceClientProtocol
extension IKTableController: IKDataSourceClient {
    func updateWithModel(model: IKModelTableUpdate) {
        DispatchQueue.main.async {
            switch model.updateType {
            case .reset:
                self.stopLoadingView()
                self.tableView.tableFooterView = UIView()
                self.tableView.reloadData()

            case .reload:
                self.tableView.reloadData()

            case .update:
                let values = model.params!

                self.tableView.beginUpdates()
                self.tableView.insertSections(values.sectionsInsert, with: .top)
                self.tableView.deleteSections(values.sectionsDelete, with: .fade)
                self.tableView.reloadSections(values.sectionsUpdate, with: .fade)
                self.tableView.insertRows(at: values.rowsInsert, with: .top)
                self.tableView.deleteRows(at: values.rowsDelete, with: .fade)
                self.tableView.reloadRows(at: values.rowsUpdate, with: .fade)
                self.tableView.endUpdates()
            }
        }
    }
}
