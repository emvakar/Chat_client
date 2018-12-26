//
//  IKHeaderView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

public class IKHeaderView: UIView {

    // MARK: - Properties

    public var label: UILabel? = UILabel()
    var detailLabel: UILabel? = UILabel()

    // MARK: - Lyfe cycle

    public convenience init() {
        self.init(frame: .zero)
    }

    public convenience init(text: String?, uppercased: Bool = true) {
        self.init()
        self.label?.text = uppercased ? text?.uppercased() : text

    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.label?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.label?.textColor = UIColor.gray

        self.detailLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.detailLabel?.textColor = UIColor.gray

        self.label?.numberOfLines = 0
        self.backgroundColor = UIColor.RGB(r: 239, g: 239, b: 244)
        self.addSubview(self.label!)
        self.label?.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(16)
            maker.top.equalToSuperview().offset(23)
            maker.bottom.equalToSuperview().offset(-5)
            maker.right.equalToSuperview().offset(-40)
        }
        self.addSubview(self.detailLabel!)
        self.detailLabel?.numberOfLines = 1
        self.detailLabel?.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-16)
            maker.top.equalTo(self.label!)
        }
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.RGB(r: 210, g: 210, b: 210)
        self.addSubview(separatorView)
        separatorView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalTo(1)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom accessors

    public func updateTitle(_ text: String?, uppercased: Bool = true) {
        self.label?.text = uppercased ? text?.uppercased() : text
    }

    public func setTitleDetailValue(_ title: String, _ details: String? = nil, uppercasedTitle: Bool = false, uppercasedDetail: Bool = false) {
        self.label?.text = uppercasedTitle ? title.uppercased() : title
        if let detailsText = details {
            self.detailLabel?.text = uppercasedDetail ? detailsText.uppercased() : detailsText
        }
    }
}
