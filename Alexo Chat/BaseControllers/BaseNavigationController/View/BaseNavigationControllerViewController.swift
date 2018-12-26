//
//  BaseNavigationControllerViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 14/09/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

class BaseNavigationControllerViewController: UINavigationController {

    var presenter: BaseNavigationControllerPresenterProtocol!

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        self.navigationBar.accessibilityLabel = "navigHeader"
        self.navigationBar.accessibilityIdentifier = "navigHeader"
        self.navigationBar.isOpaque = true
        self.navigationBar.isTranslucent = false
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = ThemeManager.currentTheme().mainColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()

    }

    private func createUI() {
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        let isDarkTheme = (ThemeManager.currentTheme() == .dark)
        return isDarkTheme ? .lightContent : .default
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }

}

extension BaseNavigationControllerViewController: BaseNavigationControllerViewProtocol { }
