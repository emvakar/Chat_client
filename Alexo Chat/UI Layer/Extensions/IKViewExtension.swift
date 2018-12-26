//
//  UIView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - safe insets
public extension UIView {

    public var safeArea: ConstraintBasicAttributesDSL {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.snp
            }
            return self.snp
        #else
            return self.snp
        #endif
    }
}

// MARK: - separators
public extension UIView {

    public enum SeparatorPosition {
        case top
        case right
        case bottom
        case left
    }

    public func addSeparators(_ positions: [SeparatorPosition]) {

        var convertedPositions = [(SeparatorPosition, UIEdgeInsets?)]()
        for position in positions {

            convertedPositions.append((position, nil))
        }
        self.addSeparators(convertedPositions)
    }

    public func addSeparators(_ positions: [(SeparatorPosition, UIEdgeInsets?)]) {

        let color = UIColor.RGB(r: 200, g: 199, b: 204)
        let pixelSize = 1.0 / UIScreen.main.scale

        for positionTuple in positions {

            let separator = UIView()
            separator.backgroundColor = color
            self.addSubview(separator)

            separator.snp.makeConstraints {

                switch positionTuple.0 {
                case .top:
                    $0.top.equalToSuperview().offset(positionTuple.1?.top ?? 0)
                    $0.left.equalToSuperview().offset(positionTuple.1?.left ?? 0)
                    $0.right.equalToSuperview().offset(-(positionTuple.1?.right ?? 0))
                    $0.height.equalTo(pixelSize)
                case .right:
                    $0.top.equalToSuperview().offset(positionTuple.1?.top ?? 0)
                    $0.right.equalToSuperview().offset(-(positionTuple.1?.right ?? 0))
                    $0.bottom.equalToSuperview().offset(-(positionTuple.1?.bottom ?? 0))
                    $0.width.equalTo(pixelSize)
                case .bottom:
                    $0.left.equalToSuperview().offset(positionTuple.1?.left ?? 0)
                    $0.right.equalToSuperview().offset(-(positionTuple.1?.right ?? 0))
                    $0.bottom.equalToSuperview().offset(-(positionTuple.1?.bottom ?? 0))
                    $0.height.equalTo(pixelSize)
                case .left:
                    $0.left.equalToSuperview().offset(positionTuple.1?.left ?? 0)
                    $0.top.equalToSuperview().offset(positionTuple.1?.top ?? 0)
                    $0.bottom.equalToSuperview().offset(-(positionTuple.1?.bottom ?? 0))
                    $0.width.equalTo(pixelSize)
                }
            }
        }
    }
}
