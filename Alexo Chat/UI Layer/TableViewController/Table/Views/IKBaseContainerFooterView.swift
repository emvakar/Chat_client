//
//  IKBaseContainerFooterView.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Footer state
public enum IKTableFooterType {
    case empty
    case loader
    case noContent
    case error
    case nextPageError
}

// MARK: - IKBaseContainerFooterView
open class IKBaseContainerFooterView: IKBaseFooterView {

    open func displayState(_ contentState: IKTableFooterType) { }
}
