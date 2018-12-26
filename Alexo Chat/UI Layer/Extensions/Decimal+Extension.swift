//
//  Decimal+Extension.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

extension Decimal {

    func getFormatted(places: Int, unit: String?) -> String {

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = places

        if let unit = unit {

            formatter.currencySymbol = " " + unit
        } else {

            formatter.currencySymbol = ""
        }

        return formatter.string(from: self as NSDecimalNumber) ?? ""
    }

    func getPriceString() -> String {

        return (self as NSDecimalNumber?)?.getFormatted() ?? ""
    }
}
