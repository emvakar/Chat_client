//
//  UIBuilder.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public enum ViewOrientation {
    case vertical
    case horizontal
}

public struct Getter {

    public func defaultInsets () -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    public func detailsInsets () -> UIEdgeInsets {
        var insets = self.defaultInsets()
        insets.top = 10
        insets.bottom = 24
        return insets
    }
}

public struct Maker {

    public func headerView(title: String? = nil, details: String? = nil) -> IKHeaderView {

        let header = IKHeaderView()
        if let titleText = title {
            header.setTitleDetailValue(titleText, details)
        }

        return header
    }

    public func filler(orientation: ViewOrientation? = nil, size: Float? = nil) -> UIView {

        let view = UIView()
        if let orientation = orientation, let size = size {

            view.snp.makeConstraints({

                if orientation == .vertical {
                    $0.height.equalTo(size)
                } else {
                    $0.width.equalTo(size)
                }
            })
        }
        return view
    }

    public func stackView(orientation: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = orientation
        stackView.distribution = distribution
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = spacing
        return stackView
    }

    public func roundButtonWith(title: String, icon: UIImage? = nil, titleInsets: UIEdgeInsets? = nil, height: CGFloat = 44, arrow: Bool = false, textAlighnment: UIControl.ContentHorizontalAlignment = .center, white: Bool = true, mainColor: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = white ? UIColor.white : mainColor
        button.setTitleColor(white ? mainColor : UIColor.white, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.contentHorizontalAlignment = textAlighnment
        if titleInsets != nil {
            button.contentEdgeInsets = titleInsets!
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = height / 2
        button.setTitle(title, for: .normal)
        if icon != nil {
            let iconView = UIImageView(image: icon!)
            iconView.contentMode = .scaleAspectFit
            button.addSubview(iconView)
            iconView.image? = (iconView.image?.withRenderingMode(.alwaysTemplate))!
            iconView.tintColor = mainColor
            iconView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(14)
                make.height.equalTo(44)
                make.width.equalTo(24)
            }
        }
        if arrow {
            let arrowView = UIImageView(image: UIImage(named: "ArrowRight"))
            arrowView.contentMode = .center
            arrowView.image = arrowView.image?.withRenderingMode(.alwaysTemplate)
            arrowView.tintColor = mainColor
            button.addSubview(arrowView)
            arrowView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-13)
            }
        }
        button.snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        return button
    }

    public func iconLabel(image: UIImage = UIImage(), text: String?, insets: UIEdgeInsets = UIEdgeInsets.zero, uppercased: Bool) -> IKIconLabelView {
        let modifiedText = uppercased ? text?.uppercased() : text
        return IKIconLabelView(icon: image, text: modifiedText, insets: insets)
    }

}

public struct IKUIBuilder {
    public static let make = Maker()
    public static let get = Getter()

}
