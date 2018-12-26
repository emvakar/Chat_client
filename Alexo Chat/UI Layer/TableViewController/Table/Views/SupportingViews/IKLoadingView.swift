//
//  IKLoadingView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: IKloadingView
public class IKLoadingView: IKBaseFooterView {

    // MARK: - Properties
    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    // MARK: - Default init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }

    // MARK: - Get height
    override public func getViewHeight() -> CGFloat {
        return 64
    }

}

// MARK: - Private methods
extension IKLoadingView {

    // MARK: - UI
    private func createUI() {
        self.createActivityIndicator()
        self.makeConstraints()
    }

    // MARK: - Activity indicator
    private func createActivityIndicator() {
        self.activityView.startAnimating()
        self.addSubview(self.activityView)
    }

    // MARK: - make constraints
    private func makeConstraints() {

        //Activity indicator
        self.activityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: self.activityView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0).isActive = true
    }
}
