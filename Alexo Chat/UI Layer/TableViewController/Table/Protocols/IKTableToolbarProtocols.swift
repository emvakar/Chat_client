//
//  IKBaseErrorRetryViewProtocol.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - Table->ToolBar
public protocol IKTableToToolbarProtocol where Self: UIView {
    func hideOverview(animation: Bool)
    func showOverview(animation: Bool)
}

// MARK: - Filter->Table
public protocol IKFilterToTable: class {
    func didClickFilterNotificationClose()
}
