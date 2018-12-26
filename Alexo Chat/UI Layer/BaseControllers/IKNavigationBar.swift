//
//  IKNavigationBar.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public class IKNavigationBar: UINavigationBar {

    override init(frame: CGRect) {

        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        self.layoutMargins = .zero
        for view in subviews {
            // Setting the layout margins to 0 lines the bar buttons items up at
            // the edges of the screen. You can set this to any number to change
            // the spacing.
            if #available(iOS 11.0, *) {

                view.layoutMargins = .zero
            } else {

                guard let button = view as? UIButton else {
                    continue
                }
                var frame = button.frame
                if frame.origin.x < UIScreen.main.bounds.size.width / 2 {

                    frame.origin.x = 0
                } else {

                    frame.origin.x = UIScreen.main.bounds.size.width - frame.size.width
                }
                button.frame = frame
            }
        }
    }
}
