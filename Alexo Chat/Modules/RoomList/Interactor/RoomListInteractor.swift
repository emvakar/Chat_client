//
//  RoomListInteractor.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

class RoomListInteractor: BaseInteractor { }

extension RoomListInteractor: RoomListInteractorProtocol {

    func registerUser(email: String, password: String, nickname: String, completion: @escaping (Int, CHATModelSignup?, NetworkError?) -> Void) {

        self.networkController.registerUser(nickname: nickname, email: email, password: password) { (statusCode, model, error) in
            if let error = error {
                completion(statusCode, nil, error)
                return
            }

            if let model = model {
                let bModel = CHATModelSignup(id: model.id, email: model.email, nickname: model.nickname)
                completion(statusCode, bModel, nil)
                return
            }
            completion(statusCode, nil, nil)
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (NetworkError?) -> Void) {
        self.networkController.loginUser(email: email, password: password) { (_, error) in
            if error == nil {
                self.networkController.connect()
            }
            completion(error)
        }
    }

    func getRoomsList(completion: @escaping ([CHATModelRoom], NetworkError?) -> Void) {
        self.networkController.getRooms { (apiModel, error) in
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
