//
//  UIColor.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

private var runtimeKeyAppMainColor: UInt8 = 0

public extension UIColor {

    static func RGB(r: (Int), g: (Int), b: (Int), a: (CGFloat) = 1) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }

    // To use appMainColor method, add \"Config.plist\" to your project and  insert dictionary called \"MainColor\"
    // with fields \"red\", \"green\", \"blue\", with Int values from 0 to 255 and \"alpha\" field with Float value from 0 to 1
    static func appMainColor() -> UIColor {

        // Prevent reading appMainColor from file every time
        if let appMainColor = objc_getAssociatedObject(self, &runtimeKeyAppMainColor) as? UIColor {

            return appMainColor
        } else {

            let message = "Please, add \"Config.plist\" to your project and insert dictionary called \"MainColor\" in it with fields \"red\", \"green\", \"blue\", with Int values from 0 to 255 and \"alpha\" field with Float value from 0 to 1"

            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else {
                fatalError("No file called \"Config.plist\" found in bundle\n\(message)")
            }
            guard let myDict = NSDictionary(contentsOfFile: path) else {
                fatalError("\"Config.plist\" is empty\n\(message)")
            }
            guard let colorDictionary = myDict["MainColor"] as? [String: Any] else {
                fatalError("\"Config.plist\" does not have MainColor dictionary\nInsert dictionary called \"MainColor\" with fields \"red\", \"green\", \"blue\", with Int values from 0 to 255 and \"alpha\" field with Float value from 0 to 1")
            }
            guard let r = colorDictionary["red"] as? Int,
                let g = colorDictionary["green"] as? Int,
                let b = colorDictionary["blue"] as? Int,
                let a = colorDictionary["alpha"] as? CGFloat else {
                    fatalError("\"Config.plist\": red, green or blue properties were not found\nInsert fields \"red\", \"green\", \"blue\", with Int values from 0 to 255 and \"alpha\" field with Float value from 0 to 1")
            }

            let retval = self.RGB(r: r, g: g, b: b, a: a)
            objc_setAssociatedObject(self, &runtimeKeyAppMainColor, retval, .OBJC_ASSOCIATION_COPY)
            return retval
        }
    }

    static func tkDefaultPinCodeBackground() -> UIColor {
        return self.RGB(r: 10, g: 10, b: 10, a: 0.7)
    }

    public static func tkToastBackground() -> UIColor {
        return self.RGB(r: 222, g: 223, b: 227)
    }

    public static func tkToastText() -> UIColor {
        return self.RGB(r: 90, g: 94, b: 97)
    }
}
