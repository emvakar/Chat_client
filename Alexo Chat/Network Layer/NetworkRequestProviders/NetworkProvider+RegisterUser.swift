//
//  NetworkProvider+Chat.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

// MARK: - User Methods
extension NetworkRequestProvider {

    func registerUser(nickname: String, email: String, password: String, completion: @escaping (Int, CHATSignupApiResponse?, NetworkError?) -> Void) {
        let request = CHATUserRoomListApiRequest(nickname: nickname, email: email, password: password, isAdmin: false)

        self.runRequest(request, progressResult: nil) { (statusCode, data, error) in
            if let error = error {
                completion(statusCode, nil, error)
                return
            }
            guard let data = data else {
                let error = NetworkErrorStruct(statusCode: nil, data: nil)
                completion(statusCode, nil, error)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let models = try jsonDecoder.decode(CHATSignupApiResponse.self, from: data)
                self.accountManager.setUserId(userId: models.id)
                self.accountManager.setUsername(nickname: models.nickname)
                completion(statusCode, models, nil)
            } catch let error {
                let error = NetworkErrorStruct(error: error as NSError)
                completion(statusCode, nil, error)
            }
        }
    }
}
