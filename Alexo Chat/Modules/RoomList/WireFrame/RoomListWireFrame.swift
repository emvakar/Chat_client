//
//  RoomListWireFrame.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

class RoomListWireFrame: BaseWireFrame {

}

extension RoomListWireFrame: RoomListWireFrameProtocol {
    func presentRoomController(from view: RoomListViewProtocol?, room: CHATModelRoom) {
        guard let fromView = view as? UIViewController else { return }
        let viewController = self.resolver.presentMessagesViewController(room: room)
        viewController.navigationItem.title = room.name
        fromView.navigationController?.pushViewController(viewController, animated: true)
    }
}
