//
//  ThemeManager.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 14.09.2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Themes preferences
enum Theme: Int {

    // перечисления использующихся тем
    case dark
    case light

    // основные цвета
    var mainColor: UIColor {
        switch self {
        case .dark:
            return UIColor.appMainColor()
        case .light:
            return UIColor.white
        }
    }

    var tableBackground: UIColor {
        switch self {
        case .dark:
            return UIColor.RGB(r: 20, g: 20, b: 20)
        default:
            return UIColor.white
        }
    }
}

// MARK: - Theme manager
class ThemeManager {

    // current theme
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: StringKeys.selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            applyTheme(theme: .dark)
            return .dark
        }
    }

    // применяем новую тему к Appirience и сохраняем в userDefaults
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: StringKeys.selectedThemeKey)
        UserDefaults.standard.synchronize()

    }
}
