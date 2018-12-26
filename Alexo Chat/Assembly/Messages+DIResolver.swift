//
//  DIResolver+Messages.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Messages
protocol MessagesProtocol {
    func presentMessagesViewController(room: CHATModelRoom) -> UIViewController
}

extension DIResolver: MessagesProtocol {
    func presentMessagesViewController(room: CHATModelRoom) -> UIViewController {
        let viewController = MessagesViewController()
        let interactor = MessagesInteractor(networkController: self.networkController)
        let wireFrame = MessagesWireFrame(resolver: self)
        let presenter = MessagesPresenter(view: viewController, wireFrame: wireFrame, interactor: interactor, accountManager: self.accountManager, room: room)
        viewController.presenter = presenter
        return viewController
    }
}
