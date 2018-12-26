//
//  IKTableConfigurationStruct.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - IKTableView view options (e.g. SearchBar, ToolBar, Refresh, Paged)
public struct IKTableOptions: OptionSet {
    public let rawValue: Int

    public static let paged          = IKTableOptions(rawValue: 1 << 0)
    public static let refreshControl = IKTableOptions(rawValue: 1 << 1)
    public static let searchBar      = IKTableOptions(rawValue: 1 << 2)
    public static let toolBar        = IKTableOptions(rawValue: 1 << 3)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
