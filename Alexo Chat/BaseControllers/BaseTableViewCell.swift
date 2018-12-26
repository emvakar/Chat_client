//
//  BaseTableViewCell.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 05/11/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
