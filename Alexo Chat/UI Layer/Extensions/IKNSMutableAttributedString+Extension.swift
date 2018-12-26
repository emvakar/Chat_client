//
//  IKNSMutableAttributedString+Extension.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    @discardableResult
    public func bold(_ text: String, fontSize: CGFloat, color: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: fontSize), .foregroundColor: color]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(boldString)
        return self
    }

    @discardableResult
    public func normal(_ text: String, fontSize: CGFloat, color: UIColor = .black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize), .foregroundColor: color]
        let normalString = NSMutableAttributedString(string: text, attributes: attrs)
        self.append(normalString)
        return self
    }
}
