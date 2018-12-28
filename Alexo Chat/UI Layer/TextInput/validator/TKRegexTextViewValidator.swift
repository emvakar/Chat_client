//
//  IKRegexTextViewValidator.swift
//  Alamofire
//
//  Created by Emil Karimov on 05/09/2018.
//

import UIKit

public class IKRegexTextViewValidator: IKTextEditViewValidator {

    public var regexInput: String? // Regexp to validate text during input
    public var regexFinal: String? // Regexp to determine if Done button should be active

    public init() {

    }

    public func shouldChangeTextTo(_ text: String, oldLength: Int) -> Bool {

        guard let regexInput = self.regexInput else {
            return true
        }
        if text.range(of: regexInput, options: .regularExpression, range: nil, locale: nil) != nil {

            return true
        }
        return false
    }

    public func shouldEnableDoneButtonBy(text: String?) -> Bool {

        guard let regexFinal = self.regexFinal else {
            return true
        }
        let text = text ?? ""
        if text.range(of: regexFinal, options: .regularExpression, range: nil, locale: nil) != nil {

            return true
        }
        return false
    }
}
