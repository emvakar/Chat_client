//
//  IKBaseRetryView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Base retry error view
public class IKPageLoaderErrorView: IKBaseFooterView {

    // MARK: - Properties
    private var titleLabel = UILabel()
    private var retryButton = IKTappableButton(type: .custom)
    private var activityView = UIActivityIndicatorView(style: .white)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IKTableToViewProtocol
    override public func displayActivity(_ inProgress: Bool) {
        inProgress ? startLoadingView() : stopLoadingView()
    }

    override public func getViewHeight() -> CGFloat {
        return 64
    }
}

// MARK: - Custom init
extension IKPageLoaderErrorView {
    convenience init(title: String = "Произошла ошибка", imageName: String = "IKRetryIcon", backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.retryButton.setImage(UIImage.init(named: imageName), for: .normal)
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Actions
extension IKPageLoaderErrorView {
    @objc func retryAction() {
        self.startLoadingView()
    }
}

// MARK: - Private methods
extension IKPageLoaderErrorView {

    // MARK: - UI subviews
    private func createUI() {
        self.createTitleLabel()
        self.createRetryButton()
        self.createActivityIndicator()

        self.makeConstraints()
    }

    // MARK: - Label
    private func createTitleLabel() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.text = "Произошла ошибка"
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
    }

    // MARK: - Button
    private func createRetryButton() {
        let bundel = getBundle()
        let image = UIImage(named: "IKRetryIcon", in: bundel, compatibleWith: nil)
        self.retryButton.setImage(image, for: .normal)
        self.retryButton.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
        self.addSubview(self.retryButton)
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
        self.addSubview(self.activityView)
    }

    // MARK: - Make constraints
    private func makeConstraints() {
        NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 44).isActive = true

        //Button
        self.retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.retryButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.retryButton, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: self.retryButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 44).isActive = true
        NSLayoutConstraint(item: self.retryButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 44).isActive = true

        //Label
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 64).isActive = true

        //Activity indicator
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.retryButton, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0).isActive = true
    }

    private func stopLoadingView() {
        DispatchQueue.main.async {
            if self.activityView.isAnimating {
                self.activityView.stopAnimating()
                self.retryButton.isHidden = !self.activityView.isHidden
            }
        }
    }

    private func startLoadingView() {
        DispatchQueue.main.async {
            if !self.activityView.isAnimating {
                self.activityView.startAnimating()
                self.retryButton.isHidden = !self.activityView.isHidden
                self.delegate?.fetchNextPageFromView(self)
            }
        }
    }
}
