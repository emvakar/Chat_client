//
//  BaseTabBarControllerViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 14/09/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

//class BaseTabBarControllerViewController: UITabBarController {
//
//    var presenter: BaseTabBarControllerPresenterProtocol!
//    private var resolver: DIResolver! = nil
//
//    init(resolver: DIResolver) {
//        self.resolver = resolver
//        super.init(nibName: nil, bundle: nil)
//        self.viewControllers = self.getControllers().compactMap({
//            BaseNavigationControllerViewController(rootViewController: $0)
//        })
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.createUI()
//    }
//
//    private func createUI() {
//        self.view.backgroundColor = ThemeManager.currentTheme().mainColor
//
//        self.tabBar.isOpaque = false
//        self.tabBar.isTranslucent = false
//        self.tabBar.barStyle = UIBarStyle.black
//        self.tabBar.shadowImage = UIImage()
//        self.tabBar.tintColor = .white
//        self.tabBar.barTintColor = ThemeManager.currentTheme().mainColor
//    }
//
//    private func getControllers() -> [UIViewController] {
//
//        let marketController = self.resolver.presentMarketListViewController()
//        marketController.tabBarItem = UITabBarItem(title: "Магазин", image: UIImage(named: "iconMarket"), tag: 0)
//
//        let cherdagramController = self.resolver.presentCherdagramViewController()
//        cherdagramController.tabBarItem = UITabBarItem(title: "Блог", image: UIImage(named: "iconBlog"), tag: 1)
//
//        let youtubeController = self.resolver.presentYouTubeListViewController(musicPlayer: self.resolver.musicPlayer)
//        let image = UIImage(named: "mediaSelect")
//        image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        youtubeController.tabBarItem = UITabBarItem.init(title: "Медиа", image: UIImage(named: "youTubeIcon"), selectedImage: image)
//        youtubeController.tabBarItem.tag = 2
//
//        let chatController = self.resolver.presentChatListViewController()
//        chatController.tabBarItem = UITabBarItem(title: "Общение", image: UIImage(named: "iconChat"), tag: 3)
//
//        let pollsController = self.resolver.presentPollsViewController()
//        pollsController.tabBarItem = UITabBarItem(title: "Призы", image: UIImage(named: "iconPrizes"), tag: 4)
//
//        return [marketController, cherdagramController, youtubeController, chatController, pollsController]
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        let isDarkTheme = (ThemeManager.currentTheme() == .dark)
//        return isDarkTheme ? .lightContent : .default
//    }
//}
//
//extension BaseTabBarControllerViewController: BaseTabBarControllerViewProtocol { }
//
//extension BaseTabBarControllerViewController: UITabBarControllerDelegate { }
