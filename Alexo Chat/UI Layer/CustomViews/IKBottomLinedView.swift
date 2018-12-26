//
//  IKBottomLinedView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public class IKBottomLinedView: UIView {

    private var bottomLine = UIView()

    public var lineBackground: UIColor = .RGB(r: 200, g: 199, b: 204)
    public var alternativeBackground: UIColor = .RGB(r: 241, g: 84, b: 90)

    public convenience init(lineBackground: UIColor, alternativeBackground: UIColor) {
        self.init(frame: .zero, insets: .zero)
        self.lineBackground = lineBackground
        self.alternativeBackground = alternativeBackground
    }

    init(frame: CGRect, insets: UIEdgeInsets) {
        super.init(frame: frame)

        self.bottomLine.backgroundColor = lineBackground
        self.addSubview(self.bottomLine)
        self.bottomLine.snp.makeConstraints {
            $0.left.equalToSuperview().offset(insets.left)
            $0.top.equalTo(self.snp.bottom).offset(-1)
            $0.right.equalToSuperview().offset(-insets.right)
            $0.bottom.equalToSuperview()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setError(enabled: Bool) {
        self.bottomLine.backgroundColor = enabled ? alternativeBackground : lineBackground
    }

    public func setBottomLine(hidden: Bool) {
        self.bottomLine.isHidden = hidden
    }
}
