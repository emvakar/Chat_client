//
//  RoomListProtocols.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

protocol RoomListViewProtocol: class {
    func stopLoadingWithState(_ state: IKTableContentState)
    func stopLoadingBySearchText(_ text: String?)
    func insertItems(_ models: [CHATModelRoom])
    func removeModel()

    func showRoomListAlert()

    func showHUD(_ message: String)
    func stopHUD()
    func setCreateRoomButton()
}

protocol RoomListWireFrameProtocol: class {
    func presentRoomController(from view: RoomListViewProtocol?, room: CHATModelRoom)
}

protocol RoomListPresenterProtocol: class {
    func viewDidLoad()
    func registerUser(email: String, password: String, nickname: String)
    func loginUser(email: String, password: String)

    func getRooms()
    func reloadRooms()

    func didClick(item: CHATModelRoom)

    func createRoom(name: String, shared: Bool)
}

protocol RoomListInteractorProtocol: class {
    func registerUser(email: String, password: String, nickname: String, completion: @escaping(Int, CHATModelSignup?, NetworkError?) -> Void)
    func loginUser(email: String, password: String, completion: @escaping(NetworkError?) -> Void)

    func getRoomsList(completion: @escaping([CHATModelRoom], NetworkError?) -> Void)
    func createRoom(name: String, shared: Bool, completion: @escaping (CHATRoomAPIResponse?, NetworkError?) -> Void)

}
