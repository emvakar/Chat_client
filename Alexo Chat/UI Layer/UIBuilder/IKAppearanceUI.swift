//
//  IKAppearanceUI.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

@objc public class IKAppearanceUI: NSObject {

    public static func segmentControlUI(items: [String], selector: Selector, target: UIViewController, backgroundColor: UIColor) -> UISegmentedControl {
        let segmentControl = UISegmentedControl.init(items: items)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.layer.cornerRadius = 5
        segmentControl.tintColor = UIColor.white
        segmentControl.addTarget(target, action: selector, for: .valueChanged)
        segmentControl.backgroundColor = backgroundColor

        return segmentControl
    }

    public static func toolBarUI(toolbar: UIToolbar, target: UIViewController, toolBarButtonItems: [UIBarButtonItem], barTintColor: UIColor) {
        toolbar.isTranslucent = false
        toolbar.barStyle = .default
        toolbar.barTintColor = barTintColor
        toolbar.tintColor = UIColor.white
        toolbar.setItems(toolBarButtonItems, animated: true)
    }

}
