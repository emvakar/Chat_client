//
//  IKFilterNotificationStruct.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

//NARK: - IKFilterNotificationStruct
struct IKFilterNotificationStruct {
    var textColor = UIColor.lightGray
    var backgroundColor = UIColor.init(red: 255.0 / 255.0, green: 146.0 / 255.0, blue: 72.0 / 255.0, alpha: 0.1)
    var closeImage = UIImage(named: "IKcloseFilterNotification", in: IKFilterNotificationStruct.getBundle(), compatibleWith: nil)

    init() { }

    // MARK: - Get bundle
    static func getBundle() -> Bundle? {
        var bundle: Bundle?
        if let urlString = Bundle.main.path(forResource: "IKInterfaceSwift", ofType: "framework", inDirectory: "Frameworks") {
            bundle = (Bundle(url: URL(fileURLWithPath: urlString)))
        }
        return bundle
    }
}
