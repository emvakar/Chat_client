//
//  IKCurtainView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Base curtain view
public class IKCurtainView: IKBaseFooterView {

    // MARK: - Properties
    public var activityView = UIActivityIndicatorView(style: .gray)
    public var labelMessage = UILabel()
    public var buttonRetry = IKTappableButton()
    public var spacerView = UIView()
    public var cachedMessage: String?

    private var buttonRetryIcon: UIImage?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    public convenience init(buttonRetryIcon: UIImage?) {
        self.init()
        self.buttonRetryIcon = buttonRetryIcon
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IKTableToViewProtocol
    override public func displayActivity(_ inProgress: Bool) {
        inProgress ? startLoadingView() : stopLoadingView()
    }

    override public func getViewHeight() -> CGFloat {
        var labelWidth: CGFloat = 0
        if let app = UIApplication.shared.delegate, let window = app.window, let windowWidth = window?.frame.size.width {
            labelWidth = windowWidth - 16
        }

        let size = CGSize(width: labelWidth, height: CGFloat(MAXFLOAT))
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: self.labelMessage.font]
        let rectangleHeight = String(describing: self.labelMessage.text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedString.Key: Any], context: nil).height

        return (40 + 20 + 40 + 42 + rectangleHeight)
    }
}

//AMRK: - Actions
extension IKCurtainView {
    @objc func retryAction() {
        self.startLoadingView()
    }
}

// MARK: - Public methods
extension IKCurtainView {

    // MARK: - Custom init
    public convenience init(message: String?, backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.labelMessage.text = message
        self.backgroundColor = backgroundColor
    }

    // MARK: - Update message
    public func updateMessage(message: String?, afterSuccess: Bool = false) {
        self.cachedMessage = message
        if !afterSuccess {
            self.labelMessage.text = message
            self.cachedMessage = nil
        }
    }
}

// MARK: - Private methods
extension IKCurtainView {

    // MARK: - UI
    private func createUI() {
        self.createLabel()
        self.createButton()
        self.createActivityIndicator()
        self.createSpacer()
        self.makeConstraints()
    }

    //AMRK: - Label
    private func createLabel() {
        self.labelMessage.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.labelMessage.textColor = ThemeManager.currentTheme().tableBackground
        self.labelMessage.textAlignment = .center
        self.labelMessage.numberOfLines = 0
        self.addSubview(self.labelMessage)
    }

    // MARK: - Button
    private func createButton() {
        let templateImage = self.buttonRetryIcon == nil ? UIImage(named: "retry") : self.buttonRetryIcon
        self.buttonRetryIcon = templateImage?.withRenderingMode(.alwaysTemplate)

        self.buttonRetry.setImage(self.buttonRetryIcon, for: .normal)
        self.buttonRetry.tintColor = ThemeManager.currentTheme().tableBackground
        self.buttonRetry.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        self.addSubview(self.buttonRetry)
    }

    public func setRetryButton(_ image: UIImage?) {
        self.buttonRetry.setImage(image, for: UIControl.State.normal)
    }

    public func setNewAction(target: Any?, _ action: Selector) {
        self.buttonRetry.removeTarget(self, action: #selector(retryAction), for: .touchUpInside)
        self.buttonRetry.addTarget(target, action: action, for: .touchUpInside)
    }

    // MARK: - Get bundle
    private func getBundle() -> Bundle? {
        var bundle: Bundle?
        if let urlString = Bundle.main.path(forResource: "IKInterfaceSwift", ofType: "framework", inDirectory: "Frameworks") {
            bundle = (Bundle(url: URL(fileURLWithPath: urlString)))
        }
        return bundle
    }

    // MARK: - Activity indicator
    private func createActivityIndicator() {
        self.activityView.hidesWhenStopped = true
        self.activityView.style = .whiteLarge
        self.activityView.color = ThemeManager.currentTheme().tableBackground
        self.addSubview(self.activityView)
    }

    //Spacer
    private func createSpacer() {
        self.addSubview(self.spacerView)
    }

    //Make contraint
    private func makeConstraints() {
        //Label
        self.labelMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.labelMessage, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: self.labelMessage, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: self.labelMessage, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -8).isActive = true

        //Button
        self.buttonRetry.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.labelMessage, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40).isActive = true

        //Activity indicator
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0).isActive = true

        //Spacer
        self.spacerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.buttonRetry, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.spacerView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 42).isActive = true
    }

    private func startLoadingView() {
        DispatchQueue.main.async {
            if !self.activityView.isAnimating {
                self.activityView.startAnimating()
                self.buttonRetry.isHidden = true
                self.delegate?.fetchNextPageFromView(self)
            }
        }
    }

    private func stopLoadingView() {
        DispatchQueue.main.async {
            if self.activityView.isAnimating {
                self.activityView.stopAnimating()
                self.buttonRetry.isHidden = false
            }
        }
    }
}
