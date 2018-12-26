//
//  BaseTabBarControllerWireFrame.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 14/09/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

class BaseTabBarControllerWireFrame: BaseWireFrame { }

extension BaseTabBarControllerWireFrame: BaseTabBarControllerWireFrameProtocol {

    func getMarketModule() -> UIViewController {
        return UIViewController()
    }

    func getCherdagramModule() -> UIViewController {
        return UIViewController()
    }

    func getVideoLineModule() -> UIViewController {
        return UIViewController()
    }

    func getPollsModule() -> UIViewController {
        return UIViewController()
    }

}
