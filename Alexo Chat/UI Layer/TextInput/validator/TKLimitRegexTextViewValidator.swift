//
//  IKLimitRegexTextViewValidator.swift
//  IKInterfaceSwift
//
//  Created by Yuriy Kolbasinskiy on 23/08/2018.
//  Copyright © 2018 TAXCOM. All rights reserved.
//

import Foundation

public class IKLimitRegexTextViewValidator: IKTextEditViewValidator {

    public var requestLength = 0
    public var characterLimit = 0
    public var regex: String?

    @available(*, deprecated, message: "use IKRegexTextViewValidator instead")
    public init() {

    }

    public func shouldChangeTextTo(_ text: String, oldLength: Int) -> Bool {

        let isLimitPassed = self.characterLimit < 1 || text.count <= self.characterLimit

        guard let regex = self.regex, isLimitPassed else {
            return isLimitPassed
        }

        var matchesCount: Int = 0

        do {
            let expression = try NSRegularExpression.init(pattern: regex, options: [])
            let matches = expression.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            matchesCount = matches.count
        } catch let error {
            print(error)
            return false
        }

        return matchesCount == 2 && isLimitPassed
    }

    public func shouldEnableDoneButtonBy(text: String?) -> Bool {
        if self.requestLength < 1 {
            return true
        }

        return text != nil && text!.count == requestLength
    }
}
