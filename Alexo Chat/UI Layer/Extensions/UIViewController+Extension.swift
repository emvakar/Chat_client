//
//  UIViewController+Extension.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public extension UIViewController {

    private struct AssociatedObjectKeys {
        static var toastView = "UIViewControllerAssociatedObjectKey_toastView"
    }

    private var toastView: IKToastView? {
        get { return objc_getAssociatedObject(self, &AssociatedObjectKeys.toastView) as? IKToastView }
        set { objc_setAssociatedObject(self, &AssociatedObjectKeys.toastView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }

    public func showToast(message: String) {
        self.toastView?.fadeOut(force: true)

        let newToast = IKToastView()
        self.toastView = newToast
        newToast.messageText = message
        newToast.show()
    }
}
