//
//  IKNavigationController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

struct ScreenSize {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_4S = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5_5S_SE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7_8 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P_8P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
}

protocol IKNavColorProtocol {
    func setMainColor(_ color: UIColor)
}

class IKNavigationController: UINavigationController, IKNavColorProtocol {
    private static let MAX_SCREEN_WIDTH_FOR_DEFAULT_OFFSET: CGFloat = 375

    init(rootViewController: UIViewController, useCustomNavigationBarClass: Bool, navigationBarClass: AnyClass? = nil) {

        if useCustomNavigationBarClass {

            let customClass: AnyClass = navigationBarClass ?? IKNavigationBar.self
            super.init(navigationBarClass: customClass, toolbarClass: nil)
            self.setViewControllers([rootViewController], animated: false)
        } else {

            super.init(rootViewController: rootViewController)
        }
    }

    override init(rootViewController: UIViewController) {

        super.init(rootViewController: rootViewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.accessibilityLabel = "navigHeader"
        self.navigationBar.accessibilityIdentifier = "navigHeader"
        self.navigationBar.isOpaque = false
        self.navigationBar.isTranslucent = false
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .white
    }

    open func setMainColor(_ color: UIColor) {
        self.navigationBar.barTintColor = color
    }

    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)

        for viewController in viewControllers {

            self.setLeftNavigationButton(for: viewController)
            self.setRightNavigationButton(for: viewController)
        }
    }

    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {

        if self.topViewController === viewController {
            return
        }

        super.pushViewController(viewController, animated: animated)
        self.setLeftNavigationButton(for: viewController)
        self.setRightNavigationButton(for: viewController)
    }

    open func setLeftNavigationButton(for controller: UIViewController) {

        if let vc = controller as? IKBaseViewController {

            vc.makeLeftBarButtonItems()
        }
    }

    open func setRightNavigationButton(for controller: UIViewController) {

        if let vc = controller as? IKBaseViewController {

            vc.makeRightBarButtonItems()
        }
    }
}
