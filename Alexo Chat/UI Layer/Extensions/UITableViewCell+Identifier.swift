//
//  UITableViewCell+Identifier.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

public protocol UITableViewCellIdentifierProvider: class {

    static func getIdentifier() -> String
}

extension UITableViewCell: UITableViewCellIdentifierProvider {

    static public func getIdentifier() -> String {

        return String(describing: self)
    }
}
