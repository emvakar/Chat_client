//
//  ToolBarNotificationView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - IKToolBarNotificationView
public class IKToolBarNotificationView: UIView {

    // MARK: - Properties
    weak var delegate: IKFilterToTable?
    private var substrateView = UIView()
    private var labelTopNotification = UILabel()
    private var labelBottomNotification = UILabel()
    private var closeBtn = UIButton(type: .custom)
    private var notificationViewContent: IKFilterNotificationStruct! = nil

    // MARK: - Default Init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom init
    init(notificationViewContent: IKFilterNotificationStruct = IKFilterNotificationStruct()) {
        super.init(frame: .zero)
        self.notificationViewContent = notificationViewContent
        self.backgroundColor = UIColor.white
        self.createUI()
    }
}

// MARK: - Actions
extension IKToolBarNotificationView {
    @objc private func closeAction() {
        self.delegate?.didClickFilterNotificationClose()
    }
}

// MARK: - Public methods
extension IKToolBarNotificationView {
    public func setNotificationText(topText: NSAttributedString?, bottomText: NSAttributedString?) {
        self.labelTopNotification.attributedText = topText
        self.labelBottomNotification.attributedText = bottomText
    }
}

// MARK: - Private methods
extension IKToolBarNotificationView {

    //UI
    private func createUI() {
        self.createSubstrate()
        self.createLabelTop()
        self.createLabelBottom()
        self.createButton()

        self.makeConstraints()
    }

    //Substrait
    private func createSubstrate() {
        self.substrateView.backgroundColor = self.notificationViewContent.backgroundColor
        addSubview(substrateView)
    }

    //Button
    private func createButton() {
        self.closeBtn.setImage(self.notificationViewContent.closeImage, for: .normal)
        self.closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.substrateView.addSubview(self.closeBtn)
    }

    //Top label
    private func createLabelTop() {
        self.labelTopNotification.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.labelTopNotification.textColor = self.notificationViewContent.textColor
        self.labelTopNotification.numberOfLines = 1
        self.labelTopNotification.lineBreakMode = .byTruncatingTail
        self.substrateView.addSubview(self.labelTopNotification)
    }

    //Bottom label
    private func createLabelBottom() {
        self.labelBottomNotification.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.labelBottomNotification.textColor = self.notificationViewContent.textColor
        self.labelBottomNotification.numberOfLines = 1
        self.labelBottomNotification.lineBreakMode = .byTruncatingTail
        self.substrateView.addSubview(self.labelBottomNotification)
    }

    //Make Constraint
    private func makeConstraints() {
        self.substrateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

       self.closeBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(25)
            $0.width.equalTo(25)
        }

        self.labelTopNotification.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalTo(self.closeBtn).offset(-8)
        }

        self.labelBottomNotification.snp.makeConstraints {
            $0.top.equalTo(self.labelTopNotification.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalTo(self.labelTopNotification)
            $0.bottom.equalToSuperview().offset(-4)
        }
    }
}
