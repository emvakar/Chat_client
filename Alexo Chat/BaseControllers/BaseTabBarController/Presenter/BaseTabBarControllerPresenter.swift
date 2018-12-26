//
//  BaseTabBarControllerPresenter.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 14/09/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

class BaseTabBarControllerPresenter: BasePresenter {

    weak var view: BaseTabBarControllerViewProtocol?
    private var wireFrame: BaseTabBarControllerWireFrameProtocol
    private var interactor: BaseTabBarControllerInteractorProtocol

    init(view: BaseTabBarControllerViewProtocol, wireFrame: BaseTabBarControllerWireFrameProtocol, interactor: BaseTabBarControllerInteractorProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireFrame = wireFrame
    }
}

extension BaseTabBarControllerPresenter: BaseTabBarControllerPresenterProtocol {
    func getControllersToTabBar() -> [UIViewController] {
        let market = self.wireFrame.getMarketModule()
        let gram = self.wireFrame.getCherdagramModule()
        let video = self.wireFrame.getVideoLineModule()
        let polls = self.wireFrame.getPollsModule()
        return [market, gram, video, polls]
    }
}
