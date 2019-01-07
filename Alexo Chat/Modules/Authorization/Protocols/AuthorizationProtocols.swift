//
//  AuthorizationProtocols.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 07/01/2019.
//  Copyright © 2019 Emil Karimov. All rights reserved.
//

import UIKit

protocol AuthorizationViewProtocol: class {
    func showLoader()
    func hideLoader()
}

protocol AuthorizationWireFrameProtocol: class {
    func presentRoomList(from view: AuthorizationViewProtocol?)
}

protocol AuthorizationPresenterProtocol: class {
    func registerUser(email: String, password: String, nickname: String)
    func loginUser(email: String, password: String)
}

protocol AuthorizationInteractorProtocol: class {
    func registerUser(email: String, password: String, nickname: String, completion: @escaping(Int, CHATModelSignup?, NetworkError?) -> Void)
    func loginUser(email: String, password: String, completion: @escaping(NetworkError?) -> Void)
}
