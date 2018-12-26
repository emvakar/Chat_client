//
//  UILabel.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public extension UILabel {
    public static func makeLabel(size: CGFloat = 13, weight: UIFont.Weight = .regular, color: UIColor = UIColor.black) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }
}
