//
//  String + Unwrap.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - validation
public extension String {

    func isValidEmail() -> Bool {

        let regexp = "^([A-Za-z0-9_\\-]+\\.)*[A-Za-z0-9_\\-]+@([A-Za-z0-9\\-]*[A-Za-z0-9]\\.)+[A-Za-z]{2,6}$"
        if self.range(of: regexp, options: .regularExpression, range: nil, locale: nil) != nil {

            return true
        }
        return false
    }

    func isValidKPP() -> Bool {

        guard self.count == 9 else {
            return false
        }

        let regexp = "^\\d{4}[\\dA-Z][\\dA-Z]\\d{3}$"
        if self.range(of: regexp, options: .regularExpression, range: nil, locale: nil) != nil {
            return true
        }
        return false
    }

    func isValidINN() -> Bool {

        switch self.count {
        case 10:

            let factorValues = [2, 4, 10, 3, 5, 9, 4, 6, 8]
            guard self.validateInnChecksum(factorValues: factorValues, endOffset: 1) else {
                return false
            }
            return true
        case 12:

            let factorValues = [3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8]
            guard self.validateInnChecksum(factorValues: factorValues, endOffset: 1) && self.validateInnChecksum(factorValues: factorValues, endOffset: 2) else {
                return false
            }
            return true
        default:

            return false
        }
    }

    private func validateInnChecksum(factorValues: [Int], endOffset: Int) -> Bool {

        let digits = self.compactMap { Int(String($0)) }
        guard digits.count == self.count else {
            return false
        }
        let testEndLength = self.count - endOffset
        guard testEndLength < digits.count else {
            return false
        }
        let trimmedDigits = Array(digits.prefix(testEndLength))
        let checksum = self.getInnChecksum(in: trimmedDigits, factorValues: factorValues)
        return checksum == digits[testEndLength]
    }

    private func getInnChecksum(in values: [Int], factorValues: [Int]) -> Int {

        var retval = 0
        let valuesCount = values.count
        let factorOffset = factorValues.count - valuesCount
        for i in 0..<valuesCount {

            let digit = values[i]
            let factorValue = factorValues[i + factorOffset]
            retval += digit * factorValue
        }
        return (retval % 11) % 10
    }
}

// MARK: - utility
public extension String {

    public static func unwrap(_ text: String?, placeholder: String = "-") -> String {

        if let text = text {

            return text.isEmpty ? placeholder : text
        } else {

            return placeholder
        }
    }

    func createStringByLimit(_ limit: Int) -> String {
        let nsString = self as NSString
        if nsString.length >= limit {
            let limittedText = nsString.substring(with: NSRange(location: 0, length: nsString.length > limit ? limit : nsString.length))
            return "\(limittedText)..."
        }
        return self
    }

    func setCenteredPlaceHolder() -> String {
        let text = self
        if text.last! != " " {
            let maxSize = CGSize(width: UIScreen.main.bounds.size.width - 97, height: 40)
            let widthText = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: nil, context: nil).size.width
            let widthSpace = " ".boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: nil, context: nil).size.width
            let spaces = floor((maxSize.width - widthText) / widthSpace)
            let newText = text + ((Array(repeating: " ", count: Int(spaces)).joined(separator: "")))
            if newText != text {
                return newText
            }
        }
        return self
    }

    public func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }

    func formatPhone() -> String {
        if self.count < 1 {
            return self
        }

        var formatted = ""
        var countSinceLastSpace = 0
        var groupCount = 2

        for char in self.reversed() {

            if countSinceLastSpace == groupCount {
                countSinceLastSpace = 0
                formatted = " \(formatted)"
            }

            if formatted.count > 6 {
                groupCount = 3
            }

            formatted = "\(char)\(formatted)"
            countSinceLastSpace += 1
        }

        return formatted
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }

    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
