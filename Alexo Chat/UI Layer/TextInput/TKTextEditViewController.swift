//
//  IKTextEditViewController.swift
//  TKInterfaceSwift
//
//  Created by Emil Karimov on 11.04.2018.
//  Copyright © 2018 TAXCOM. All rights reserved.
//

import UIKit
import SnapKit
import Cosmos

public enum IKTextEditType {
    case textField
    case textView
}

public protocol IKTextEditViewDelegate: class {
    func textEditViewController(_ textEdit: IKTextEditViewController, textDidChange text: String?, rating: Int?)
}

public protocol IKTextEditViewValidator: class {
    func shouldChangeTextTo(_ text: String, oldLength: Int) -> Bool
    func shouldEnableDoneButtonBy(text: String?) -> Bool
}

public extension IKTextEditViewDelegate {
    func textEditViewController(_ textEdit: IKTextEditViewController, textDidChange text: String?, rating: Int?) {

    }
}

open class IKTextEditViewController: IKBaseViewController {

    // MARK: - Properties

    public weak var delegate: IKTextEditViewDelegate?
    public var validator: IKTextEditViewValidator?
    public var previousString: String?
    public var keyboardType: UIKeyboardType = .default
    public var isSecureTextEntry: Bool = false
    public var textEditType: IKTextEditType = .textField
    public var showRating: Bool = false

    public var doneIconName: String?

    private var textView = UITextView()
    private var textField = UITextField()
    private var ratingView: CosmosView!

    private var doneBtn: UIBarButtonItem! = nil

    // MARK: - Life cycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch textEditType {
        case .textField:
            self.textField.becomeFirstResponder()
            self.textDidChangeAction(sender: self.textField)
        case .textView:
            self.textView.becomeFirstResponder()
            self.textChangedAction(sender: self.textView)
        }
    }

    // MARK: - Action

    @objc func doneClickedAction(sender: UIBarButtonItem) {
        guard let delegate = self.delegate else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        switch textEditType {
        case .textField:
            delegate.textEditViewController(self, textDidChange: self.textField.text, rating: Int(self.ratingView.rating))
        case .textView:
            delegate.textEditViewController(self, textDidChange: self.textView.text, rating: Int(self.ratingView.rating))
        }
        self.navigationController?.popViewController(animated: true)
    }

    @objc func textDidChangeAction(sender: UITextField) {
        self.doneBtn.isEnabled = self.validator?.shouldEnableDoneButtonBy(text: sender.text) ?? true
    }

    @objc func textChangedAction(sender: UITextView) {
        self.doneBtn.isEnabled = self.validator?.shouldEnableDoneButtonBy(text: sender.text) ?? true
    }

    // MARK: - Public

    public func setPlaceholder(_ string: String?) {
        self.textField.placeholder = string
    }

    // MARK: - Private

    open func createUI() {

        let settings = CosmosSettings()

        self.ratingView = CosmosView(settings: settings)
        self.ratingView.rating = 0
        self.ratingView.settings.starMargin = 2
        self.ratingView.settings.starSize = 35

        let separateView = UIView()
        separateView.backgroundColor = .gray

        //UI
        self.view.backgroundColor = ThemeManager.currentTheme().tableBackground
        let insets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)

        let doneBtnImage = UIImage(named: "ActionIcon")
        let doneBtn = UIBarButtonItem.item(icon: doneBtnImage, target: self, action: #selector(self.doneClickedAction(sender:)), accessibilityName: "DoneButton")
        self.doneBtn = doneBtn
        self.navigationItem.setRightBarButton(doneBtn, animated: false)

        if showRating {
            self.view.addSubview(self.ratingView)
            self.view.addSubview(separateView)
            self.ratingView.snp.makeConstraints { (make) in
                make.top.equalTo(self.view.safeArea.top).offset(insets.top)
                make.centerX.equalToSuperview()
            }

            separateView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.ratingView.snp.bottom).offset(1)
                make.height.equalTo(1)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
        }

        switch textEditType {
        case .textField:

            self.textField.textAlignment = .left
            self.textField.contentVerticalAlignment = .top
            self.textField.addTarget(self, action: #selector(textChangedAction(sender:)), for: .editingChanged)
            self.textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            self.textField.keyboardType = self.keyboardType
            self.textField.delegate = self
            self.textField.isSecureTextEntry = self.isSecureTextEntry
            self.textField.keyboardAppearance = ThemeManager.currentTheme() == .dark ? .dark : .default
            self.textField.backgroundColor = ThemeManager.currentTheme().tableBackground
            self.textField.tintColor = .white
            self.textField.textColor = .white

            self.textField.text = self.previousString
            self.view.addSubview(self.textField)

            //Constraint
            self.textField.snp.makeConstraints { (maker) in
                maker.top.equalTo(self.showRating ? separateView.snp.bottom : self.view.safeArea.top).offset(insets.top)
                maker.bottom.equalTo(self.view.safeArea.bottom).offset(-insets.bottom)
                maker.left.equalTo(self.view.safeArea.left).offset(insets.left)
                maker.right.equalTo(self.view.safeArea.right).offset(-insets.right)
            }
        case .textView:

            self.textView.textAlignment = .left
            self.textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            self.textView.keyboardType = self.keyboardType
            self.textView.delegate = self
            self.textView.isSecureTextEntry = self.isSecureTextEntry
            self.textView.keyboardAppearance = ThemeManager.currentTheme() == .dark ? .dark : .default
            self.textView.backgroundColor = ThemeManager.currentTheme().tableBackground
            self.textView.tintColor = .white
            self.textView.textColor = .white

            self.textView.text = self.previousString
            self.view.addSubview(self.textView)

            //Constraint
            self.textView.snp.makeConstraints { (maker) in
                maker.top.equalTo(self.showRating ? separateView.snp.bottom : self.view.safeArea.top).offset(insets.top)
                maker.bottom.equalTo(self.view.safeArea.bottom).offset(-insets.bottom)
                maker.left.equalTo(self.view.safeArea.left).offset(insets.left)
                maker.right.equalTo(self.view.safeArea.right).offset(-insets.right)
            }
        }
    }
}

extension IKTextEditViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldValue = (textField.text ?? "") as NSString
        let newValue = oldValue.replacingCharacters(in: range, with: string)
        return self.validator?.shouldChangeTextTo(newValue, oldLength: oldValue.length) ?? true
    }
}

extension IKTextEditViewController: UITextViewDelegate {
    // MARK: - UITextViewDelegate

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let oldValue = (textView.text ?? "") as NSString
        let newValue = oldValue.replacingCharacters(in: range, with: text)
        return self.validator?.shouldChangeTextTo(newValue, oldLength: oldValue.length) ?? true
    }

    public func textViewDidChange(_ textView: UITextView) {
        self.textChangedAction(sender: textView)
    }

}
