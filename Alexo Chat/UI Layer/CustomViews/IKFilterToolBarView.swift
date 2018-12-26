//
//  IKFilterToolBarView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public struct IKFilterToolbarViewContent {
    let backgroundColor: UIColor
    let barTintColor: UIColor
    let tintColor = UIColor.white
    let barStyle = UIBarStyle.default
    let toolbarHeight = 44

    public init(background: UIColor, barTint: UIColor) {
        self.backgroundColor = background
        self.barTintColor = barTint
    }

}

public class IKFilterToolbarView: UIView {

    private var notificationView: IKFilterNotificationView! = nil
    private var filterToolbar: UIToolbar! = nil
    private var notificationBottomConstraint: Constraint! = nil
    private var toolbarTopConstraint: Constraint! = nil

    internal var filterToolbarViewContent: IKFilterToolbarViewContent = IKFilterToolbarViewContent(background: .white, barTint: .white)

    public var closeDelegate: IKFilterNotificationViewDelegate? {
        get {
            return notificationView.delegate
        }

        set {
            notificationView.delegate = newValue
        }
    }

    public init(filterToolbarViewContent: IKFilterToolbarViewContent, filterNotificationView: IKFilterNotificationView) {

        self.filterToolbarViewContent = filterToolbarViewContent
        self.notificationView = filterNotificationView

        super.init(frame: .zero)

        self.backgroundColor = filterToolbarViewContent.backgroundColor

        createToolbarView()
        createNotifcationView()
        makeConstraint()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createNotifcationView() {
        addSubview(notificationView)
    }

    private func createToolbarView() {

        filterToolbar = UIToolbar()
        filterToolbar.isTranslucent = false
        filterToolbar.clipsToBounds = true

        filterToolbar.backgroundColor = filterToolbarViewContent.backgroundColor
        filterToolbar.tintColor = filterToolbarViewContent.tintColor
        filterToolbar.barStyle = filterToolbarViewContent.barStyle
        filterToolbar.barTintColor = filterToolbarViewContent.barTintColor

        addSubview(filterToolbar)
    }

    private func makeConstraint() {

        notificationView.snp.makeConstraints {
            $0.top.equalToSuperview().priority(900)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            self.notificationBottomConstraint = $0.bottom.equalTo(filterToolbar.snp.top).constraint
        }

        filterToolbar.snp.makeConstraints {
            $0.top.equalToSuperview().priority(400)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(filterToolbarViewContent.toolbarHeight)
        }
    }

    public func setItems(items: [UIBarButtonItem]) {
        filterToolbar.setItems(items, animated: true)
    }

    public func setOverviewTextFor(topLine: NSAttributedString?, bottomLine: NSAttributedString?) {

        let isVisible = topLine?.length ?? 0 > 0 || bottomLine?.length ?? 0 > 0
        notificationView.setNotificationText(topText: topLine, bottomText: bottomLine)

        if isVisible {
            self.showOverview()
        } else {
            self.hideOverview()
        }
    }

    public func hideOverview() {

        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.notificationBottomConstraint.update(offset: self.filterToolbarViewContent.toolbarHeight)
            self.superview?.layoutIfNeeded()
        }
    }

    private func showOverview() {

        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.notificationBottomConstraint.update(offset: 0)
            self.superview?.layoutIfNeeded()
        }
    }
}
