//
//  NetworkRequestWrapper.swift
//  Parlist
//
//  Created by Emil Karimov on 31.08.2018.
//  Copyright © 2018 ESKARIA Corporation. All rights reserved.
//

import Foundation

protocol NetworkMessangerRequestProtocol {
    func registerUser(nickname: String, email: String, password: String, completion: @escaping(Int, CHATSignupApiResponse?, NetworkError?) -> Void)
    func loginUser(email: String, password: String, completion: @escaping(CHATLoginApiResponse?, NetworkError?) -> Void)

    func getRooms(offset: Int, limit: Int, searchText: String?, completion: @escaping(CHATRoomsAPIResponse?, NetworkError?) -> Void)
    func inviteUser(to roomId: String, userId: String, completion: @escaping(NetworkError?) -> Void)
    func getMessages(from roomId: String, completion: @escaping(CHATMessagesAPIResponse?, NetworkError?) -> Void)
    func sendMessage(to roomId: String, text: String, completion: @escaping(CHATMessageAPIResponse?, NetworkError?) -> Void)
    func sendMessage(toUser id: String, text: String, completion: @escaping(CHATMessageAPIResponse?, NetworkError?) -> Void)

    // MARK: - admins methods
    func createRoom(name: String, shared: Bool, completion: @escaping(CHATRoomAPIResponse?, NetworkError?) -> Void)
}
