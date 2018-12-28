//
//  DIResolver+Chat.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 28/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Chat
protocol ChatProtocol {
    func presentChatViewController(room: CHATModelRoom) -> UIViewController
}

extension DIResolver: ChatProtocol {
    func presentChatViewController(room: CHATModelRoom) -> UIViewController {
        let viewController = ChatViewController()
        let interactor = ChatInteractor(networkController: self.networkController)
        let wireFrame = ChatWireFrame(resolver: self)
        let presenter = ChatPresenter(view: viewController, wireFrame: wireFrame, interactor: interactor, accountManager: self.accountManager, room: room)
        viewController.presenter = presenter
        return viewController
    }
}
