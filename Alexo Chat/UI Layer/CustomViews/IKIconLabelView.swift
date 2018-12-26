//
//  IconLabelView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public class IKIconLabelView: UIView {

    public var label: UILabel! = UILabel()//size: 13, weight: UIFont.Weight.regular.rawValue, color: UIColor.appHeadertextColor())
    public var iconView: UIImageView! = nil
    var insets: UIEdgeInsets?

    public convenience init() {
        self.init(frame: .zero)
    }
    public convenience init(icon: UIImage = UIImage(), text: String? = nil, insets: UIEdgeInsets = UIEdgeInsets.zero) {

        self.init()
        self.label?.text = text
        self.label.numberOfLines = 0
        self.iconView = UIImageView(image: icon)
        self.iconView.contentMode = .scaleAspectFit
        self.insets = insets

        let container = UIView()
        self.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(self.insets ?? UIEdgeInsets.zero)
        }

        container.addSubview(self.iconView)
        self.iconView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().offset(2)
            $0.width.equalTo(13)
            $0.height.equalTo(13)
        }

        container.addSubview(self.label)
        self.label.snp.makeConstraints {
            $0.left.equalTo(self.iconView.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setText(_ text: String, uppercased: Bool = false) {
        self.label.text = uppercased ? text.uppercased() : text
    }
}
