//
//  NetworkProvider+Chat.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

// MARK: - Admin Methods
extension NetworkRequestProvider {
    func createRoom(name: String, shared: Bool, completion: @escaping (CHATRoomAPIResponse?, NetworkError?) -> Void) {
        let request = CHATCreateRoomApiRequest(name: name, shared: shared)

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
                let models = try jsonDecoder.decode(CHATRoomAPIResponse.self, from: data)
                completion(models, nil)
            } catch let error {
                let error = NetworkErrorStruct(error: error as NSError)
                completion(nil, error)
            }
        }
    }
}
