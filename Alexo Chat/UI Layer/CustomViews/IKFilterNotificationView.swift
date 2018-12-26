//
//  IKFilterNotificationView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

public protocol IKFilterNotificationViewDelegate: class {
    func didClickFilterNotificationClose()
}

public struct IKFilterNotificationViewContent {

    public var textColor: UIColor
    public var backgroundColor: UIColor
    public var closeImage: UIImage

    public init(textColor: UIColor, backgroundColor: UIColor, closeImage: UIImage) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.closeImage = closeImage
    }
}

public class IKFilterNotificationView: UIView {

    weak var delegate: IKFilterNotificationViewDelegate?
    private var labelTopNotification: UILabel! = nil
    private var labelBottomNotification: UILabel! = nil
    private var closeBtn: UIButton! = nil

    public init(textColor: UIColor, backgroundColor: UIColor, closeImage: UIImage) {
        super.init(frame: .zero)

        self.backgroundColor = UIColor.white

        let filterNotificationViewContent = IKFilterNotificationViewContent(textColor: textColor, backgroundColor: backgroundColor, closeImage: closeImage)

        let substrateView = UIView()
        substrateView.backgroundColor = filterNotificationViewContent.backgroundColor
        addSubview(substrateView)

        substrateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.labelTopNotification = UILabel.makeLabel(size: 13, weight: .regular, color: filterNotificationViewContent.textColor)
        self.labelTopNotification.numberOfLines = 1
        self.labelTopNotification.lineBreakMode = .byTruncatingTail

        self.labelBottomNotification = UILabel.makeLabel(size: 13, weight: .regular, color: filterNotificationViewContent.textColor)
        self.labelBottomNotification.numberOfLines = 1
        self.labelBottomNotification.lineBreakMode = .byTruncatingTail

        self.closeBtn = UIButton(type: .custom)
        self.closeBtn.setImage(filterNotificationViewContent.closeImage, for: .normal)
        self.closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)

        substrateView.addSubview(closeBtn)
        substrateView.addSubview(labelTopNotification)
        substrateView.addSubview(labelBottomNotification)

        self.closeBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(25)
            $0.width.equalTo(25)
        }

        self.labelTopNotification.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalTo(closeBtn).offset(-8)
        }

        self.labelBottomNotification.snp.makeConstraints {
            $0.top.equalTo(labelTopNotification.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalTo(labelTopNotification)
            $0.bottom.equalToSuperview().offset(-4)
        }

        self.labelTopNotification.accessibilityLabel    = "FoS field 1"
        self.labelBottomNotification.accessibilityLabel = "FoS field 2"
        self.closeBtn.accessibilityLabel                = "Reset FoS button"
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func closeAction() {
        self.delegate?.didClickFilterNotificationClose()
    }

    public func setNotificationText(topText: NSAttributedString?, bottomText: NSAttributedString?) {
        self.labelTopNotification.attributedText = topText
        self.labelBottomNotification.attributedText = bottomText
    }
}
