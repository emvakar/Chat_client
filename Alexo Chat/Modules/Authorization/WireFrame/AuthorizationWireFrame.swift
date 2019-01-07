//
//  AuthorizationWireFrame.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 07/01/2019.
//  Copyright © 2019 Emil Karimov. All rights reserved.
//

import UIKit

class AuthorizationWireFrame: BaseWireFrame {
    //func presentSomeViewController(from view: AuthorizationViewProtocol) {
    //    guard let fromView = view as? UIViewController else { return }
    //    let viewController = self.resolver.someViewController()
    //    fromView.navigationController?.pushViewController(viewController, animated: true)
    //}
}

extension AuthorizationWireFrame: AuthorizationWireFrameProtocol {
    func presentRoomList(from view: AuthorizationViewProtocol?) {
        guard let fromView = view as? UIViewController else { return }
        let viewController = UINavigationController(rootViewController: self.resolver.presentRoomListViewController())
        fromView.present(viewController, animated: true, completion: nil)
    }
    

}
