//
//  IKEmailTextViewValidator.swift
//  IKInterfaceSwift
//
//  Created by Yuriy Kolbasinskiy on 23/08/2018.
//  Copyright © 2018 TAXCOM. All rights reserved.
//

import Foundation

public class IKEmailTextViewValidator: IKTextEditViewValidator {
    public init() {

    }

    public func shouldChangeTextTo(_ text: String, oldLength: Int) -> Bool {
        return true
    }

    public func shouldEnableDoneButtonBy(text: String?) -> Bool {
        guard let text = text else {
            return false
        }
        return text.isValidEmail()
    }
}
