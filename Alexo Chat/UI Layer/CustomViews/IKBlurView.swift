//
//  IKBlurView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

public class IKBlurView {

    private let window: UIWindow?
    private var tag: Int
    private var style: UIBlurEffect.Style

    public init(_ window: UIWindow?, style: UIBlurEffect.Style = .light, customTag: Int = 123) {
        self.window = window
        self.tag = customTag
        self.style = style
    }

    public func showBlurView() {
        guard let window = window, (window.viewWithTag(self.tag) == nil)  else { return }
        let blurEffect = UIBlurEffect(style: self.style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.frame
        blurEffectView.tag = self.tag
        window.addSubview(blurEffectView)
    }

    public func removeBlurView() {
        guard let view = self.window?.viewWithTag(self.tag) else { return }
        view.removeFromSuperview()
    }
}
