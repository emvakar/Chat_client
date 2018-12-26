//
//  IKDisclouserView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

public class IKDisclosureView: IKBottomLinedView {

    public let btnClickableArea = UIButton(type: .custom)

    private static let ARROW_RIGHT_OFFSET = 16
    private let arrowView = UIImageView(image: IKInterfaceImageProvider.getImage("DisclosureIndicator"))
    private let labelTitle = UILabel.makeLabel(size: 13, weight: .regular, color: UIColor.RGB(r: 200, g: 199, b: 204))
    private let labelValue = UILabel.makeLabel(size: 15, weight: .regular)

    private var constraintCenter: Constraint! = nil
    private var editable: Bool = true

    public var title: String? {
        didSet {

            self.labelTitle.text = title
            self.invalidate()
        }
    }
    public var value: String? {
        didSet {

            self.labelValue.text = value
            self.invalidate()
        }
    }
    public var valueColorEnabled: UIColor = .black {
        didSet {

            self.setEditable(self.editable)
        }
    }
    public var valueColorDisabled: UIColor = .black {
        didSet {

            self.setEditable(self.editable)
        }
    }

    public init(title: String? = nil, value: String? = nil, insets: UIEdgeInsets, editable: Bool = true, infoButton: UIButton? = nil) {

        super.init(frame: .zero, insets: insets)

        self.editable = editable
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(44)
        }

        self.arrowView.setContentHuggingPriority(.required, for: .horizontal)
        self.addSubview(self.arrowView)
        self.arrowView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-(insets.right + 16))
            $0.height.equalTo(13)
            $0.width.equalTo(8)
        }

        self.labelTitle.text = title
        self.addSubview(self.labelTitle)
        self.labelTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(insets.left)
            $0.right.equalTo(self.arrowView.snp.left).offset(-10)
        }

        self.labelValue.numberOfLines = 0
        self.addSubview(self.labelValue)
        self.labelValue.snp.makeConstraints {
            $0.left.equalToSuperview().offset(insets.left)
            $0.top.equalTo(self.labelTitle.snp.bottom).priority(900)
            $0.right.equalTo(self.arrowView.snp.left).offset(-10)
            $0.bottom.equalToSuperview().offset(-2).priority(900)
            self.constraintCenter = $0.centerY.equalToSuperview().priority(999).constraint
        }

        self.addSubview(self.btnClickableArea)
        self.btnClickableArea.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        if let infoButton = infoButton {

            self.addSubview(infoButton)
            infoButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(30)
                $0.width.equalTo(30)
                $0.right.equalTo(self.arrowView.snp.left).offset(-12)
            }
        }
        self.setEditable(editable)

        self.labelTitle.text = title
        self.labelValue.text = value

        self.title = title
        self.value = value
        self.invalidate()
    }

    public func setEditable(_ editable: Bool) {

        self.labelValue.textColor = editable ? self.valueColorEnabled : self.valueColorDisabled
        self.editable = editable
        self.arrowView.isHidden = !editable
        self.btnClickableArea.isHidden = !self.editable
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func willMove(toSuperview newSuperview: UIView?) {

        super.willMove(toSuperview: newSuperview)
        self.invalidate()
    }

    private func invalidate() {

        if let value = self.value, !value.isEmpty {

            self.labelTitle.isHidden = false
            self.constraintCenter.deactivate()
        } else {

            self.labelTitle.isHidden = true
            self.labelValue.text = title
            self.constraintCenter.activate()
        }
    }
}
