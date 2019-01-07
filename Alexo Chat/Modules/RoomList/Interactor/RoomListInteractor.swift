//
//  RoomListInteractor.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

class RoomListInteractor: BaseInteractor { }

extension RoomListInteractor: RoomListInteractorProtocol {

    func getRoomsList(offset: Int, limit: Int, searchText: String?, completion: @escaping ([CHATModelRoom], NetworkError?) -> Void) {
        self.networkController.getRooms(offset: offset, limit: limit, searchText: searchText) { (apiModel, error) in
            var roomsModel = [CHATModelRoom]()
            if let models = apiModel {
                models.forEach { roomsModel.append(CHATModelRoom(from: $0)) }
            }

            completion(roomsModel, error)
        }
    }

    func createRoom(name: String, shared: Bool, completion: @escaping (CHATRoomAPIResponse?, NetworkError?) -> Void) {
        self.networkController.createRoom(name: name, shared: shared, completion: completion)
    }
}
