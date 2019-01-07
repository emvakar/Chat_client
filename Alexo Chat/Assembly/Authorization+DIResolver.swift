//
//  DIResolver+Authorization.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 07/01/2019.
//  Copyright © 2019 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Authorization
protocol AuthorizationProtocol {
    func presentAuthorizationViewController() -> UIViewController
}

extension DIResolver: AuthorizationProtocol {
    func presentAuthorizationViewController() -> UIViewController {
        let viewController = AuthorizationViewController()
        let interactor = AuthorizationInteractor(networkController: self.networkController)
        let wireFrame = AuthorizationWireFrame(resolver: self)
        let presenter = AuthorizationPresenter(view: viewController, wireFrame: wireFrame, interactor: interactor)

        presenter.accountManager = self.accountManager
        presenter.wsManager = self.webSocketManager
        viewController.presenter = presenter

        return viewController
    }
}
