//
//  RoomListViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit
import DataSources
import StatusProvider
import PagingTableView
import NotificationBannerSwift
import MessageKit

class RoomListViewController: BaseViewController {

    var presenter: RoomListPresenterProtocol!

    private var tableView: PagingTableView = PagingTableView()
    private var dataController: SectionDataController<CHATModelRoom, TableViewAdapter>!
    private let searchController = UISearchController(searchResultsController: nil)

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RoomListViewController.handleRefresh(_:)), for: .valueChanged)

        return refreshControl
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.presenter.viewDidAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.presenter.viewDidLoad()

    }

    private func createUI() {

        self.navigationItem.title = "Комнаты"
        self.view.backgroundColor = .white

        self.tableView.refreshControl = self.refreshControl
        navigationItem.searchController = self.searchController
        self.searchController.delegate = self

        self.dataController = SectionDataController<CHATModelRoom, TableViewAdapter>(adapter: TableViewAdapter(tableView: self.tableView), isEqual: { $0.id == $1.id })
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.pagingDelegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RoomCell")

        self.view.addSubview(self.tableView)

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always

        self.edgesForExtendedLayout = .all

        self.tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

    }

    func setCreateRoomButton() {
        let button = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(createRoomAction(_:)))
        self.navigationItem.rightBarButtonItem = button
    }
}

// MARK: - Private
extension RoomListViewController {
    @objc private func createRoomAction(_ sender: UIBarButtonItem) {

        self.showAlertController(style: .alert) { alert in

            alert.title = "Создание комнаты"

            alert.addTextField(configurationHandler: { (tf) in
                tf.placeholder = "Наименование комнаты"
            })

            let action = UIAlertAction(title: "OK", style: .cancel, handler: { [weak alert] (_) in
                if let tf = alert?.textFields?.first, let name = tf.text, !name.isEmpty {
                    self.presenter.createRoom(name: name, shared: false)
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { (_) in

            })
            alert.addAction(action)
            alert.addAction(cancel)
        }

    }

    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        self.presenter.reloadRooms()
        self.refreshControl.endRefreshing()
    }
}

// MARK: - RoomListViewProtocol
extension RoomListViewController: RoomListViewProtocol {


    func showBanner(payload: MessagePayload) {

        let label = UILabel.makeLabel(size: 13, weight: UIFont.Weight.regular, color: .white)
        label.text = Date().formatHHMM()
        label.textAlignment = .center
        let banner = NotificationBanner(title: payload.fromUser.nickname, subtitle: payload.text, leftView: label, style: BannerStyle.info)
        banner.show()
    }

    func endFetching() {
        self.tableView.isLoading = false
    }

    func failedLoaded(_ text: String?) {
        print("show failedLoaded")
    }

    func failedNextPageLoaded(_ text: String?) {
        print("show failedNextPageLoaded")
        let banner = NotificationBanner(title: "Ошибка заргузки", subtitle: "Проверьте интернет соединение", style: BannerStyle.danger)
        banner.autoDismiss = false
        banner.show()
    }

    func showTableStatus(_ status: StatusModel) {
        self.show(status: status)
        self.tableView.isLoading = false
    }

    func hideTableStatus() {
        self.hideStatus()
    }

    func updateItems(_ items: [CHATModelRoom]) {
        self.hideStatus()

        self.dataController.update(items: items, updateMode: .partial(animated: true)) {
            // Completion update
            self.tableView.isLoading = false
        }

    }

    func reloadPages() {
        self.tableView.reset()
        let status = Status(isLoading: true, description: "Синхронизация...")
        self.show(status: status)
        self.presenter.reloadRooms()
    }

    func showHUD(_ message: String) {
        self.showLoading(message: message)
    }

    func stopHUD() {
        self.hideLoading()
    }
}

// MARK: - IKTableControllerDelegate
extension RoomListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataController.numberOfItems()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        let model = self.dataController.item(at: indexPath)
        cell.textLabel?.text = model?.name
        cell.detailTextLabel?.text = "\(model?.members.count ?? 0) пользователей"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.dataController.item(at: indexPath) else { return }
        self.presenter.didClick(item: model)
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }

}

// MARK: - UISearchBarDelegate
extension RoomListViewController: UISearchControllerDelegate {

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.isFirstResponder {
            self.view.endEditing(true)
        }

        //        self.presenter.searchBy(text: searchBar.text)
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        self.presenter.searchBy(text: searchBar.text)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = nil
        //        self.presenter.searchBy(text: searchBar.text)
    }
}

// MARK: - PagingTableViewDelegate
extension RoomListViewController: PagingTableViewDelegate {
    func paginate(_ tableView: PagingTableView, to page: Int) {
        self.tableView.isLoading = true
        self.presenter.fetchRoomsList(with: page)
    }
}
