//
//  BaseViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 13.09.2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import KRProgressHUD
import StatusProvider

class BaseViewController: UIViewController, StatusController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.setNeedsStatusBarAppearanceUpdate()

    }

    func setTitleAndImage(title: String, imageName: String, tag: Int) {
        self.title = title
        let tabImage = UIImage(named: imageName)
        self.tabBarItem = UITabBarItem(title: title, image: tabImage, tag: tag)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (ThemeManager.currentTheme() == .dark) ? .lightContent : .default
    }

    func showAlert(title: String?, message: String?, buttons: [UIAlertAction]) {
        self.showAlertController(style: .alert) {
            $0.title = title
            $0.message = message
            for button in buttons {
                $0.addAction(button)
            }
        }
    }

    func showAlertController(style: UIAlertController.Style, setupBlock: (UIAlertController) -> Void) {

        let alertController: UIAlertController = UIAlertController(title: "Ошибка", message: nil, preferredStyle: style)

        setupBlock(alertController)

        if alertController.actions.count < 1 {
            fatalError("No actions provided in alert controller")
        }

        self.present(alertController, animated: true, completion: nil)
    }

    public func showOkAlertController(title: String?, message: String?, callback: (() -> Void)? = nil) {
        self.showAlertController(style: .alert) {
            $0.title = title
            $0.message = message
            let action = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                if callback != nil {
                    callback!()
                }
            })
            $0.addAction(action)
        }
    }

    public func showLoading(message: String?) {
        if let message = message {
            KRProgressHUD.show(withMessage: message)
        } else {
            KRProgressHUD.show()
        }
    }

    public func showNotYetRealizedAlert() {
        self.showAlertController(style: .alert) {
            $0.title = "This function is not realized"
            $0.message = "Соррри"
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            $0.addAction(action)
        }
    }

    public func hideLoading() {
        KRProgressHUD.dismiss()
    }

    // MARK: - Bar button items
    open func makeLeftBarButtonItems() {
        let backImage = UIImage(named: "backIcon")
        let backBarButtonItem = UIBarButtonItem.item(icon: backImage, target: self, action: #selector(popBack(from:)), accessibilityName: "BackBarButtonItem")
        self.navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
    }

    open func makeRightBarButtonItems() {

    }

    @objc func popBack(from: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func setRightBarButtonItems(_ items: [(icon: UIImage?, target: Any, action: Selector, accessibilityName: String)]) {
        var myitems = [(icon: UIImage?, target: AnyObject?, action: Selector?, accessibilityName: String)]()
        items.forEach { (item) in
            myitems.append((icon: item.icon, target: item.target as AnyObject?, action: item.action as Selector?, accessibilityName: item.accessibilityName))
        }
        let buttonItems = UIBarButtonItem.items(myitems)
        self.navigationItem.rightBarButtonItem = buttonItems
    }

}
