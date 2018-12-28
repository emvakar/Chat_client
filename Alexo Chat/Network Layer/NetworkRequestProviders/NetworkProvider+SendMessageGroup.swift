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

    func sendMessage(to roomId: String, text: String, completion: @escaping (CHATMessageAPIResponse?, NetworkError?) -> Void) {
        let request = CHATMessageSendRoomApiRequest(roomId: roomId, text: text)

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
                let models = try jsonDecoder.decode(CHATMessageAPIResponse.self, from: data)
                completion(models, nil)
            } catch let error {
                let error = NetworkErrorStruct(error: error as NSError)
                completion(nil, error)
            }
        }
    }
}
