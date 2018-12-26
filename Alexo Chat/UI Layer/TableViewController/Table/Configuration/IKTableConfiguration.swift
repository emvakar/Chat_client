//
//  IKTableConfiguration.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - IKTableConfiguration
public class IKTableConfiguration {

    // MARK: - Properties
    let tableOptions: IKTableOptions
    let cellClasses: [AnyClass]

    // MARK: - Initialization
    public init(options: IKTableOptions, cellClasses: [AnyClass]) {
        if cellClasses.count < 1 {
            fatalError("TableViewController requires at least 1 cell class to work with")
        }

        self.tableOptions = options
        self.cellClasses = cellClasses
    }
}

// MARK: - NSCopying extesntion
extension IKTableConfiguration: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return IKTableConfiguration(options: self.tableOptions, cellClasses: self.cellClasses)
    }
}
