//
//  IKBaseFooterView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - IKBaseFooterView
open class IKBaseFooterView: UIView, IKTableToViewProtocol {

    // MARK: - Properties
    weak public var delegate: IKViewToTableProtocol?

    // MARK: - Need to override this method for connecting TableView and ErrorViews
    open func displayActivity(_ inProgress: Bool) { }
    open func getViewHeight() -> CGFloat {
        fatalError("Need to override this method to get height of view")
    }

    // MARK: - Default init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ThemeManager.currentTheme().tableBackground
    }
}
