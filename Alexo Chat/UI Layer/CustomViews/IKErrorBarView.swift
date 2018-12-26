//
//  ErrorView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

open class IKErrorBarView: UIView {

    private var label: UILabel! = nil
    private var btnClose: UIButton! = nil

    open var action: ((IKErrorBarView) -> Void)?

    convenience public init(errorMessage: String?) {
        self.init(frame: .zero)

        self.label.text = errorMessage
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.RGB(r: 241, g: 84, b: 90)

        self.btnClose = IKTappableButton(type: .custom)
        btnClose.setImage(UIImage.init(named: "IKErrorBarViewClose"), for: .normal)
        btnClose.addTarget(self, action: #selector(closeAction), for: .touchUpInside)

        addSubview(btnClose)

        btnClose.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.right.equalToSuperview().offset(-7)
            $0.width.equalTo(15)
            $0.height.equalTo(15)
        }

        self.layer.cornerRadius = 12
        self.label = UILabel.makeLabel(size: 13, weight: .regular, color: UIColor.white)
        label.numberOfLines = 0

        addSubview(label)

        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalTo(self.btnClose.snp.left).offset(-10)
            $0.bottom.equalToSuperview().offset(-9)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setErrorMessage(_ message: String?) {
        self.label.text = message
    }

    @objc func closeAction() {
        if let action = self.action {
            action(self)
        }
    }
}
