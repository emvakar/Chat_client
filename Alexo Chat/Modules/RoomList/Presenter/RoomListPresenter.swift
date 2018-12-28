//
//  RoomListPresenter.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Starscream
import StatusProvider

class RoomListPresenter: BasePresenter {

    weak var view: RoomListViewProtocol?
    private var wireFrame: RoomListWireFrameProtocol
    private var interactor: RoomListInteractorProtocol
    var accountManager: AccountManager!
    var wsManager: WebSocketManager!

    private let limit: Int = 20
    private var isLoading: Bool = false
    private var isRefreshing: Bool = false
    private var searchText: String? = nil
    private var endFetching: Bool = false


    private var rooms: [CHATModelRoom] = [] {
        didSet {
            self.view?.updateItems(self.rooms)
            if self.rooms.isEmpty {
                if !oldValue.isEmpty {
                    self.view?.hideTableStatus()
                    return
                }
                let status = Status(isLoading: false, title: "Нет ни одной комнаты", description: nil, actionTitle: "Создать", image: UIImage(named: "Icon")) {
                    self.reloadRooms()
                }
                self.view?.showTableStatus(status)
                return
            } else {
                self.view?.hideTableStatus()
            }

        }
    }


    init(view: RoomListViewProtocol, wireFrame: RoomListWireFrameProtocol, interactor: RoomListInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireFrame = wireFrame
    }

}


extension RoomListPresenter: WebSocketEventsDelegate {

    func newMessage(payload: MessagePayload) {
        if payload.type == .group { // FIXME: - Change later to .direct messages type
            self.view?.showBanner(payload: payload)
        }
    }

}

extension RoomListPresenter: RoomListPresenterProtocol {

    func viewDidAppear() {
        self.wsManager.eventDelegate = self
    }

    func viewDidLoad() {
        if (self.accountManager.getBearerToken().isEmpty) {
            self.view?.showRoomListAlert()
        } else {
            self.reloadRooms()
        }

        self.view?.setCreateRoomButton()
    }

    func registerUser(email: String, password: String, nickname: String) {

        self.interactor.registerUser(email: email, password: password, nickname: nickname) { (statusCode, model, error) in
            if let error = error {
                print(error)
                if statusCode == 500 && (error.detailMessage ?? "").contains("uq:User.email") {
                    self.loginUser(email: email, password: password)
                }
                return
            }

            if model != nil {
                self.loginUser(email: email, password: password)
            }
        }
    }

    func loginUser(email: String, password: String) {
        guard let token = (email + ":" + password).toBase64() else { return }
        self.accountManager.setUserToken(newToken: token)
        self.interactor.loginUser(email: email, password: password, completion: { (error) in
            if let error = error {
                self.accountManager.setUserToken(newToken: "")
                return
            }
            self.reloadRooms()
        })
    }

    func fetchRoomsList(with page: Int) {

        guard !isLoading else { return }
        self.isLoading = true
        if page == 0 && !self.isRefreshing { self.view?.showTableStatus(Status(isLoading: true)) }

        self.interactor.getRoomsList(offset: page * self.limit, limit: self.limit, searchText: self.searchText) { (models, error) in
            defer { self.isLoading = false; self.isRefreshing = false }
            if error != nil {

                self.view?.failedLoaded(nil)
                return
            }

            self.rooms.append(contentsOf: models)

            if models.count < self.limit {
                self.view?.endFetching()
            }
        }
    }

    func reloadRooms() {

        self.isRefreshing = true
        self.rooms.removeAll()
        self.fetchRoomsList(with: 0)

    }

    func didClick(item: CHATModelRoom) {
        self.wireFrame.presentRoomController(from: self.view, room: item)
    }

    func createRoom(name: String, shared: Bool) {
        self.view?.showHUD("Создание комнаты...")
        self.interactor.createRoom(name: name, shared: shared) { (roomApi, error) in
            defer { self.view?.stopHUD() }
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let roomResponse = roomApi {
                self.reloadRooms()
            }

        }
    }
}
