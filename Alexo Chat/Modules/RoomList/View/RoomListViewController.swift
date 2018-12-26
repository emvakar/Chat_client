//
//  RoomListViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit
import MessengerKit

class RoomListViewController: BaseViewController {

    var presenter: RoomListPresenterProtocol!

    private var tableController = IKTableController(configuration: IKTableConfiguration(options: [.refreshControl, .searchBar], cellClasses: [UITableViewCell.self]))
    private var dataSource: IKPlainDatsSource<CHATModelRoom> = IKPlainDatsSource(uniqueKeypath: "id")
    private var footerContainer: BaseTableFooterContainer! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.presenter.viewDidLoad()

    }

    private func createUI() {
        self.navigationItem.title = "Комнаты"

        self.view.backgroundColor = .white
        self.dataSource.client = self.tableController

        self.tableController.delegateSearch = self
        self.tableController.delegateDataSource = self
        self.tableController.viewProtocol = self
        self.addChild(self.tableController)
        self.view.addSubview(self.tableController.view)

        self.tableController.tableView.separatorStyle = .none

        self.tableController.view.backgroundColor = .white
        self.tableController.tableView.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .always

        self.edgesForExtendedLayout = .all
        self.tableController.tableView.contentInsetAdjustmentBehavior = .always

        self.tableController.view.snp.makeConstraints {
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
}

// MARK: - RoomListViewProtocol
extension RoomListViewController: RoomListViewProtocol {

    func stopLoadingWithState(_ state: IKTableContentState) {
        self.tableController.stopLoading(state: state)
    }

    func stopLoadingBySearchText(_ text: String?) {
        if let text = text, !text.isEmpty {
            self.footerContainer.noContentCurtain = IKCurtainView(message: ("Не найдено ни одной комнаты по запросу " + "'" + text + "'"), backgroundColor: ThemeManager.currentTheme().tableBackground)
        } else {
            self.footerContainer.noContentCurtain = IKCurtainView(message: "Нет ни одной комнаты", backgroundColor: ThemeManager.currentTheme().tableBackground)
        }

        self.footerContainer.noContentCurtain?.delegate = self.footerContainer.delegate
        self.tableController.stopLoading(state: .noContent)
    }

    func insertItems(_ items: [CHATModelRoom]) {
        self.dataSource.insertModels(models: items, animated: true)
    }

    func removeModel() {
        self.dataSource.removeModels()
    }

    func reloadPages() {
        self.removeModel()
        self.tableController.stopLoading(state: .success)
    }

    func showRoomListAlert() {

        let alert = UIAlertController(title: "Регистрация", message: "Вам нужно зарегистрироваться.", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.tag = 0
            textField.placeholder = "Email"
        }

        alert.addTextField { (textField) in
            textField.tag = 1
            textField.placeholder = "Password"
        }

        alert.addTextField { (textField) in
            textField.tag = 2
            textField.placeholder = "Nickname"
        }

        let regAction = UIAlertAction(title: "Signup", style: .default, handler: { [weak alert] (_) in
            if let tfs = alert?.textFields {

                var em: String?
                var ps: String?
                var nn: String?

                tfs.forEach {
                    if $0.tag == 0 {
                        em = $0.text
                    }
                    if $0.tag == 1 {
                        ps = $0.text
                    }
                    if $0.tag == 2 {
                        nn = $0.text
                    }
                }
                // FIXME: - убрать потом
                em = "emvakar@gmail.com"
                ps = "M8DyyeLnWLV2adNAYUmMB6AzV4F2"
                nn = "emvakar"

                guard let email = em, let password = ps, let nickname = nn else { return }
                self.presenter.registerUser(email: email, password: password, nickname: nickname)

            }
        })

        let logAction = UIAlertAction(title: "Login", style: .default, handler: { [weak alert] (_) in
            if let tfs = alert?.textFields {

                var em: String?
                var ps: String?
                var nn: String?

                tfs.forEach {
                    if $0.tag == 0 {
                        em = $0.text
                    }
                    if $0.tag == 1 {
                        ps = $0.text
                    }
                    if $0.tag == 2 {
                        nn = $0.text
                    }
                }

                // FIXME: - убрать потом
                em = "emvakar@gmail.com"
                ps = "M8DyyeLnWLV2adNAYUmMB6AzV4F2"
                nn = "emvakar"

                guard let email = em, let password = ps, let nickname = nn else { return }
                self.presenter.registerUser(email: email, password: password, nickname: nickname)

            }
        })

        alert.addAction(regAction)
        alert.addAction(logAction)

        self.present(alert, animated: true, completion: nil)
    }

    func showHUD(_ message: String) {
        self.showLoading(message: message)
    }

    func stopHUD() {
        self.hideLoading()
    }
}

// MARK: - IKTableControllerDelegate
extension RoomListViewController: IKTableControllerDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.numberOfRowsInSection(indexOfSection: section)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableController.dequeueCell(indexPath: indexPath)
        let model = self.dataSource.getModelAtIndexPath(indexPath: indexPath)
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = "\(model.members.count) пользователей"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource.getModelAtIndexPath(indexPath: indexPath)
        self.presenter.didClick(item: model)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
    }

    func pullToRefresh(tableController: IKTableController) {
        self.presenter.reloadRooms()
    }

    func fetchNextPage(tableController: IKTableController) {
        self.presenter.getRooms()
    }
}

// MARK: - IKTableToViewControllerProtocol
extension RoomListViewController: IKTableToViewControllerProtocol {
    func getFooterView() -> IKBaseContainerFooterView {
        self.footerContainer = BaseTableFooterContainer(noContentMessage: "Нет ни одной комнаты", errorMessage: "Что-то пошло не так, попробуйте позже")
        self.footerContainer.backgroundColor = ThemeManager.currentTheme().tableBackground
        return self.footerContainer
    }
}

// MARK: - UISearchBarDelegate
extension RoomListViewController: UISearchBarDelegate {

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
