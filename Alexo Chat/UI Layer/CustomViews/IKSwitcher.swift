//
//  IKSwitcher.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public protocol IKSwitcherChangeValueDelegate: class {
    func switcherDidChangeValue(switcher: IKSwitcher, value: Bool, _ completion: ((_ flag: Bool?) -> Void)?)
}

open class IKSwitcher: UIView {

    var button: UIButton!
    var buttonLeftConstraint: NSLayoutConstraint!

    public weak var delegate: IKSwitcherChangeValueDelegate?
    public var on: Bool = false

    private var originalImage: UIImage?
    private var selectedImage: UIImage?
    private var selectedColor: UIColor
    private var originalColor: UIColor

    private var offCenterPosition: CGFloat!
    private var onCenterPosition: CGFloat!

    public init(frame: CGRect = CGRect(x: 0, y: 0, width: 51, height: 31), selectedColor: UIColor = .appMainColor(), deselectedColor: UIColor = .white) {
        self.selectedColor = selectedColor
        self.originalColor = deselectedColor
        super.init(frame: frame)
        commonInit()
    }

    override open func awakeFromNib() {
        commonInit()
    }

    private func commonInit() {
        button = UIButton(type: .custom)
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switcherButtonTouch(_:)), for: UIControl.Event.touchUpInside)
        button.setImage(originalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        offCenterPosition = self.bounds.height * 0.1
        onCenterPosition = self.bounds.width - (self.bounds.height * 0.9)

        if on == true {
            self.button.backgroundColor = selectedColor
        } else {
            self.button.backgroundColor = originalColor
        }

        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
        initLayout()
        animationSwitcherButton(animated: false)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeButton(_:)))
        swipeLeft.direction = .left
        button.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeButton(_:)))
        swipeRight.direction = .right
        button.addGestureRecognizer(swipeRight)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }

    private func initLayout() {
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonLeftConstraint = button.leftAnchor.constraint(equalTo: self.leftAnchor)
        buttonLeftConstraint.isActive = true
        button.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
    }

    public func setImages(onImage: UIImage?, offImage: UIImage?) {
        button.setImage(offImage, for: .normal)
        button.setImage(onImage, for: .selected)
    }

    required public init?(coder aDecoder: NSCoder) {
        selectedColor = .green
        originalColor = .gray
        super.init(coder: aDecoder)
    }

    @objc func switcherButtonTouch(_ sender: AnyObject) {
        self.delegate?.switcherDidChangeValue(switcher: self, value: !on, { (flag) in
            if let flag = flag, flag == true { self.on = !self.on; self.animationSwitcherButton(animated: true) }
        })
    }

    @objc func swipeButton(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .right {
            if self.on == false { self.switcherButtonTouch(recognizer) }
        } else if recognizer.direction == .left {
            if self.on == true { self.switcherButtonTouch(recognizer) }
        }
    }

    public func animationSwitcherButton(animated: Bool) {
        let animationDuration: TimeInterval = animated ? 0.5 : 0.0
        if on == true {
            if animated {
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = -CGFloat(Double.pi)
                rotateAnimation.toValue = 0.0
                rotateAnimation.duration = 0.45
                rotateAnimation.isCumulative = false
                self.button.layer.add(rotateAnimation, forKey: "rotate")
            }

            UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = true
                self.buttonLeftConstraint.constant = self.onCenterPosition
                self.layoutIfNeeded()
                self.button.backgroundColor = self.selectedColor

                self.button.layer.shadowOffset = CGSize(width: 0, height: 0.2)
                self.button.layer.shadowOpacity = 0.3
                self.button.layer.shadowRadius = self.offCenterPosition
                self.button.layer.cornerRadius = self.button.frame.height / 2
                self.button.layer.shadowPath = UIBezierPath(roundedRect: self.button.layer.bounds, cornerRadius: self.button.frame.height / 2).cgPath

                self.backgroundColor = UIColor.RGB(r: 34, g: 138, b: 205, a: 0.5)
            }, completion: { (_: Bool) -> Void in
                self.layer.borderWidth = 0.5
                self.layer.borderColor = UIColor.clear.cgColor
            })
        } else {

            self.button.layer.shadowOffset = CGSize.zero
            self.button.layer.shadowOpacity = 0
            self.button.layer.shadowRadius = self.button.frame.height / 2
            self.button.layer.cornerRadius = self.button.frame.height / 2
            self.button.layer.shadowPath = nil

            if animated {
                let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotateAnimation.fromValue = 0.0
                rotateAnimation.toValue = -CGFloat(Double.pi)
                rotateAnimation.duration = 0.45
                rotateAnimation.isCumulative = false
                self.button.layer.add(rotateAnimation, forKey: "rotate")
            }

            UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = false
                self.buttonLeftConstraint.constant = self.offCenterPosition
                self.layoutIfNeeded()
                self.button.backgroundColor = self.originalColor

                self.layer.borderWidth = 0.5
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.backgroundColor = .white
            }, completion: { (_: Bool) -> Void in
            })
        }
    }
}
