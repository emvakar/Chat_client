//
//  RoomListPresenter.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Starscream

class RoomListPresenter: BasePresenter {

    weak var view: RoomListViewProtocol?
    private var wireFrame: RoomListWireFrameProtocol
    private var interactor: RoomListInteractorProtocol
    var accountManager: AccountManager!

    init(view: RoomListViewProtocol, wireFrame: RoomListWireFrameProtocol, interactor: RoomListInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireFrame = wireFrame
    }

}

extension RoomListPresenter: RoomListPresenterProtocol {

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

    func getRooms() {

        self.interactor.getRoomsList { (models, error) in
            if let error = error {
                print(error.localizedDescription)
                self.view?.removeModel()
                self.view?.stopLoadingWithState(IKTableContentState.failedLoaded)
                return
            }
            if !models.isEmpty {
                self.view?.insertItems(models)
                self.view?.stopLoadingWithState(.success)
            } else {
                self.view?.stopLoadingWithState(.noContent)
            }
        }
    }

    func reloadRooms() {
        self.view?.removeModel()
        self.getRooms()

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
