//
//  IKToastView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

public class IKToastView: UIView {
    private static let DISMISS_TIME: Double = 1.0

    private let label: UILabel
    private var configured: Bool = false

    public var messageText: String? {
        didSet { self.label.text = messageText }
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        self.label = UILabel.makeLabel(size: 13, weight: .regular, color: UIColor.black)
        self.label.textColor = UIColor.tkToastText()
        self.label.textAlignment = .center
        self.label.numberOfLines = 0

        super.init(frame: frame)
        self.backgroundColor = UIColor.tkToastBackground()
        self.layer.cornerRadius = 18

        self.addSubview(self.label)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func show() {
        guard let frontWindow = UIApplication.shared.keyWindow else { return }
        frontWindow.addSubview(self)
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        self.alpha = 0.0

        if self.window != nil {
            self.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().offset(-50)
            }

            self.label.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().offset(-10)
            }
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if configured {
            return
        }

        configured = true

        UIView.animate(withDuration: 1, animations: {
            self.layoutIfNeeded()
            self.alpha = 1.0
        }) { (success) in
            if !success {
                return
            }

            Timer.scheduledTimer(withTimeInterval: IKToastView.DISMISS_TIME, repeats: false, block: { [weak self] (_) in
                self?.fadeOut()
            })
        }
    }

    public func fadeOut(force: Bool = false) {

        if force {
            self.removeFromSuperview()
        }

        self.alpha = 1.0

        UIView.animate(withDuration: 1, animations: {
            self.layoutIfNeeded()
            self.alpha = 0.0
        }) { (success) in
            if success {
                self.removeFromSuperview()
            }
        }
    }
}
