//
//  UIButton.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - UIButton with increasing tappable area
public class IKTappableButton: UIButton {

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(x: self.bounds.origin.x - 10, y: self.bounds.origin.y - 10, width: self.bounds.size.width + 10, height: self.bounds.size.height + 10)
        return newArea.contains(point)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.adjustsImageWhenHighlighted = false
    }

}
