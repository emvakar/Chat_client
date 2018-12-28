//
//  RoomListProtocols.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import StatusProvider

protocol RoomListViewProtocol: class {

    //table events
    func failedLoaded(_ text: String?)
    func failedNextPageLoaded(_ text: String?)
    func endFetching()

    //table status
    func showTableStatus(_ status: StatusModel)
    func hideTableStatus()

    //working with items
    func updateItems(_ models: [CHATModelRoom])

    func showRoomListAlert()

    func setCreateRoomButton()

    func showHUD(_ message: String)
    func stopHUD()

    func showBanner(payload: MessagePayload)
}

protocol RoomListWireFrameProtocol: class {
    func presentRoomController(from view: RoomListViewProtocol?, room: CHATModelRoom)
}

protocol RoomListPresenterProtocol: class {
    func viewDidAppear()
    func viewDidLoad()
    func registerUser(email: String, password: String, nickname: String)
    func loginUser(email: String, password: String)

    func fetchRoomsList(with page: Int)
    func reloadRooms()

    func didClick(item: CHATModelRoom)

    func createRoom(name: String, shared: Bool)
}

protocol RoomListInteractorProtocol: class {
    func registerUser(email: String, password: String, nickname: String, completion: @escaping(Int, CHATModelSignup?, NetworkError?) -> Void)
    func loginUser(email: String, password: String, completion: @escaping(NetworkError?) -> Void)

    func getRoomsList(offset: Int, limit: Int, searchText: String?, completion: @escaping([CHATModelRoom], NetworkError?) -> Void)
    func createRoom(name: String, shared: Bool, completion: @escaping (CHATRoomAPIResponse?, NetworkError?) -> Void)

}
