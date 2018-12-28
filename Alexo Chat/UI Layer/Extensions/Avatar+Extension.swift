//
//  Avatar+Extension.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 28/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import MessageKit

extension Avatar {
    init(_ nickname: String) {
        var initials = ""

        let initialsArray = nickname.components(separatedBy: " ")
        if let firstWord = initialsArray.first {
            if let firstLetter = firstWord.first {
                initials += String(firstLetter).capitalized
            }
        }
        if initialsArray.count > 1, let lastWord = initialsArray.last {
            if let lastLetter = lastWord.first {
                initials += String(lastLetter).capitalized
            }
        }

        self.init(image: nil, initials: initials)
    }
}

