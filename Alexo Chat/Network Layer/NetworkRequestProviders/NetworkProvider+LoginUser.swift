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

    func loginUser(email: String, password: String, completion: @escaping (CHATLoginApiResponse?, NetworkError?) -> Void) {

        let request = CHATUserLoginApiRequest()

        self.runRequest(request, progressResult: nil) { (_, data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                let error = NetworkErrorStruct(statusCode: nil, data: nil)
                completion(nil, error)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let models = try jsonDecoder.decode(CHATLoginApiResponse.self, from: data)
                self.accountManager.refreshBearerToken(token: models.token)
                self.accountManager.setUsername(nickname: models.nickname)
                completion(models, nil)
            } catch let error {
                let error = NetworkErrorStruct(error: error as NSError)
                completion(nil, error)
            }
        }
    }
}
