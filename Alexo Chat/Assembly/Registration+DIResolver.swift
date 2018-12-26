//
//  DIResolver+RoomList.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - RoomList
protocol RoomListProtocol {
    func presentRoomListViewController() -> UIViewController
}

extension DIResolver: RoomListProtocol {
    func presentRoomListViewController() -> UIViewController {
        let viewController = RoomListViewController()
        let interactor = RoomListInteractor(networkController: self.networkController)
        let wireFrame = RoomListWireFrame(resolver: self)
        let presenter = RoomListPresenter(view: viewController, wireFrame: wireFrame, interactor: interactor)
        presenter.accountManager = self.accountManager
        viewController.presenter = presenter
        return viewController
    }
}
