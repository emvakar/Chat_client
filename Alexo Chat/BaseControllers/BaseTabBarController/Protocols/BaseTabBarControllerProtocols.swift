//
//  BaseTabBarControllerProtocols.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 14/09/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

protocol BaseTabBarControllerViewProtocol: class { }

protocol BaseTabBarControllerWireFrameProtocol: class {
    func getMarketModule() -> UIViewController
    func getCherdagramModule() -> UIViewController
    func getVideoLineModule() -> UIViewController
    func getPollsModule() -> UIViewController
}

protocol BaseTabBarControllerPresenterProtocol: class {
    func getControllersToTabBar() -> [UIViewController]
}

protocol BaseTabBarControllerInteractorProtocol: class { }
