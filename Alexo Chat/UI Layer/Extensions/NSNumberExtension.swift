//
//  NSNumberExtension.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

extension NSNumber {
    public func getFormatted(groupingSize: Int = 3, groupingSeparator: String = " ", numberStyle: NumberFormatter.Style = .decimal, decimalSeparator: String = ",", minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2, unit: String = "₽") -> String? {

        let formatter = NumberFormatter()
        formatter.groupingSize = groupingSize
        formatter.groupingSeparator = groupingSeparator
        formatter.numberStyle = numberStyle
        formatter.decimalSeparator = decimalSeparator
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        let price = formatter.string(from: self)
        if let p = price {
            return p + " " + unit
        }

        return formatter.string(from: self)
    }
}
