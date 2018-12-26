//
//  BaseViewController.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit
import KRProgressHUD

open class IKBaseViewController: UIViewController {

//    open override var title: String? {
//        didSet {
//            let label = UILabel.makeLabel(size: 17, weight: .semibold, color: .white)
//            label.text = title
//            if let size = title?.sizeOfString(usingFont: label.font).width, size > 0 {
//                label.textAlignment = .center
//                label.frame = CGRect(x: 0, y: 0, width: size, height: 20)
//                label.accessibilityLabel = "Navigation header title"
//                self.navigationItem.titleView = label
//                self.navigationItem.title = ""
//            } else {
//                self.navigationItem.title = ""
//            }
//        }
//    }

    // MARK: - Show alert controller
    public func showAlertController(style: UIAlertController.Style, setupBlock: (UIAlertController) -> Void) {

        let alertController: UIAlertController = UIAlertController(title: "Ошибка", message: nil, preferredStyle: style)
        alertController.view.tintColor = UIColor.appMainColor()
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

    // MARK: - Bar button items
    open func makeLeftBarButtonItems() {
        let backImage = IKInterfaceImageProvider.getImage("IKBackIcon")
        let backBarButtonItem = UIBarButtonItem.item(icon: backImage, target: self, action: #selector(popBack(from:)), accessibilityName: "BackBarButtonItem")
        self.navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
    }

    open func makeRightBarButtonItems() {

    }
}

// MARK: - Actions
extension IKBaseViewController {
    @objc func popBack(from: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
