//
//  AuthorizationInteractor.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 07/01/2019.
//  Copyright © 2019 Emil Karimov. All rights reserved.
//

class AuthorizationInteractor: BaseInteractor { }

extension AuthorizationInteractor: AuthorizationInteractorProtocol {
    
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

}
