//
//  IKDisclouserTextFieldView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - IKDisclouserTextFieldView
public protocol IKDisclouserTextFieldDelegate: UITextFieldDelegate { }

// MARK: - IKDisclouserTextFieldView
public class IKDisclouserTextFieldView: IKBottomLinedView {

    // MARK: - Properties
    public weak var delegate: IKDisclouserTextFieldDelegate?
    //Change properties to update display view
    public var animationDuration: Double = 0.15
    public var titleNormalFontSize: CGFloat = 15
    public var titleSmallFontSize: CGFloat = 13
    public var textFieldFontSize: CGFloat = 15

    private let buttonArea = UIButton(type: .custom)
    private let labelTitle = UILabel.makeLabel(size: 15, weight: .regular)
    private let textFieldValue = UITextField()
    private var constraintCenter: Constraint! = nil
    private var editable: Bool = true

    // MARK: - Custom getter/setter
    public var valueColorEnabled: UIColor = .black {
        didSet {
            self.setEditable(self.editable)
        }
    }
    public var valueColorDisabled: UIColor = .gray {
        didSet {
            self.setEditable(self.editable)
        }
    }

    // MARK: - init
    public init(title: String? = nil, value: String? = nil, placeHolder: String? = nil, insets: UIEdgeInsets = .zero, editable: Bool = true, infoButton: UIButton? = nil) {
        super.init(frame: .zero, insets: insets)

        if let ph = placeHolder, !ph.isEmpty {
            self.textFieldValue.placeholder = ph
        } else {
            self.textFieldValue.placeholder = nil
        }

        self.buttonArea.addTarget(self, action: #selector(buttonAreaAction), for: .touchUpInside)
        self.editable = editable
        self.labelTitle.text = title
        self.labelTitle.font = UIFont.systemFont(ofSize: self.titleNormalFontSize)
        self.labelTitle.numberOfLines = 0
        self.textFieldValue.text = value
        self.textFieldValue.font = UIFont.systemFont(ofSize: self.textFieldFontSize)
        self.textFieldValue.isHidden = true
        self.textFieldValue.delegate = self.delegate

        self.addSubview(self.labelTitle)
        self.addSubview(self.textFieldValue)
        self.addSubview(self.buttonArea)

        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(44)
        }

        if let infoButton = infoButton {
            self.addSubview(infoButton)
            infoButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(30)
                $0.width.equalTo(30)
                $0.right.equalToSuperview().offset(-insets.right)
            }
        }

        self.labelTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(insets.left)
            if let infoButton = infoButton {
                $0.right.equalTo(infoButton.snp.left).offset(-8)
            } else {
                $0.right.equalToSuperview().offset(-insets.right)
            }
            self.constraintCenter = $0.bottom.equalToSuperview().offset(-2).constraint
        }

        self.textFieldValue.snp.makeConstraints {
            $0.left.equalToSuperview().offset(insets.left)
            $0.top.equalTo(self.labelTitle.snp.bottom).priority(900)
            if let infoButton = infoButton {
                $0.right.equalTo(infoButton.snp.left).offset(-8)
            } else {
                $0.right.equalToSuperview().offset(-insets.right)
            }
            $0.bottom.equalToSuperview().offset(-2).priority(900)
        }

        self.buttonArea.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            if let infoButton = infoButton {
                $0.right.equalTo(infoButton.snp.left).offset(-8)
            } else {
                $0.right.equalToSuperview()
            }
        }

        self.setEditable(self.editable)
        self.updateView(animation: false, completion: { })
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MAKR: - Actions
extension IKDisclouserTextFieldView {

    @objc func buttonAreaAction() {
        self.showTextField(animation: true, completion: {
            self.textFieldValue.becomeFirstResponder()
        })
    }
}

// MARK: - Public methods
extension IKDisclouserTextFieldView {

    public func setTitle(_ title: String?) {
        self.labelTitle.text = title
    }

    public func setValue(_ value: String?, animation: Bool = false) {
        self.textFieldValue.text = value
        self.updateView(animation: animation, completion: { })
    }

    public func setEditable(_ editable: Bool) {
        self.textFieldValue.textColor = editable ? self.valueColorEnabled : self.valueColorDisabled
        self.labelTitle.textColor = editable ? self.valueColorEnabled : self.valueColorDisabled
        self.editable = editable
        self.buttonArea.isHidden = !self.editable
    }

    public func endEditingText(animation: Bool = true) {
        if self.editable {
            self.dissmissTextField(animation: animation)
        }
    }

    public func showHightLight() {
        UIView.animate(withDuration: self.animationDuration * 3, animations: {
            self.setError(enabled: true)
        }) { _ in
            UIView.animate(withDuration: self.animationDuration * 3, animations: {
                self.setError(enabled: false)
            })
        }
    }

    public func setHightLight(_ hightLight: Bool) {
        self.setError(enabled: hightLight)
    }
}

// MARK: - Private methods
extension IKDisclouserTextFieldView {

    private func updateView(animation: Bool, completion: @escaping () -> Void) {
        if let text = self.textFieldValue.text, !text.isEmpty {
            self.showTextField(animation: animation, completion: completion)
        } else {
            self.dissmissTextField(animation: animation)
        }
    }

    private func showTextField(animation: Bool, completion: @escaping () -> Void) {
        self.buttonArea.isHidden = true

        self.setNeedsLayout()
        UIView.animate(withDuration: animation ? self.animationDuration : 0, animations: {
            self.labelTitle.textColor = self.valueColorDisabled
            self.labelTitle.font = UIFont.systemFont(ofSize: self.titleSmallFontSize)
            self.constraintCenter.deactivate()
            self.layoutIfNeeded()
        }) { (complited) in
            if complited {
                self.textFieldValue.isHidden = false
                completion()
            }
        }
    }

    private func dissmissTextField(animation: Bool) {
        self.textFieldValue.resignFirstResponder()

        guard let text = self.textFieldValue.text, !text.isEmpty else {
            self.buttonArea.isHidden = false
            self.textFieldValue.isHidden = true

            self.setNeedsLayout()
            UIView.animate(withDuration: animation ? self.animationDuration : 0, animations: {
                self.labelTitle.textColor = self.valueColorEnabled
                self.labelTitle.font = UIFont.systemFont(ofSize: self.titleNormalFontSize)
                self.constraintCenter.activate()
                self.layoutIfNeeded()
            })

            return
        }
    }
}
