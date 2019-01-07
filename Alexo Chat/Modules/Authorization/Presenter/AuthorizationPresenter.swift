//
//  AuthorizationPresenter.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 07/01/2019.
//  Copyright © 2019 Emil Karimov. All rights reserved.
//

class AuthorizationPresenter: BasePresenter {

    weak var view: AuthorizationViewProtocol?
    private var wireFrame: AuthorizationWireFrameProtocol
    private var interactor: AuthorizationInteractorProtocol
    
    var accountManager: AccountManager!
    var wsManager: WebSocketManager!

    init(view: AuthorizationViewProtocol, wireFrame: AuthorizationWireFrameProtocol, interactor: AuthorizationInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireFrame = wireFrame
    }
}

extension AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    func registerUser(email: String, password: String, nickname: String) {
        self.view?.showLoader()
        self.interactor.registerUser(email: email, password: password, nickname: nickname) { (statusCode, model, error) in
            if let error = error {
                print(error)
                if statusCode == 500 {
                    self.loginUser(email: email, password: password)
                    return
                }
                self.view?.hideLoader()
                return
            }
            
            if model != nil {
                self.loginUser(email: email, password: password)
            }
        }
    }
    
    func loginUser(email: String, password: String) {
        guard let token = (email + ":" + password).toBase64() else { return }
        self.accountManager.setUserToken(newToken: token)
        self.interactor.loginUser(email: email, password: password, completion: { (error) in
            if let error = error {
                self.accountManager.setUserToken(newToken: "")
                return
            }

            self.view?.hideLoader()
            self.wireFrame.presentRoomList(from: self.view)
        })
    }
}
