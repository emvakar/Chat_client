//
//  IKInterfaceImageProvider.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

class IKInterfaceImageProvider {
    private static var bundle: Bundle?
    private static let onceTracker: () = {

        if let bundleURL = Bundle(for: IKInterfaceImageProvider.self).url(forResource: "IKInterfaceAssets", withExtension: "bundle") {

            if let bundle = Bundle(url: bundleURL) {

                IKInterfaceImageProvider.bundle = bundle
            }
        }
    }()

    static func getImage(_ named: String?) -> UIImage? {

        guard let named = named else {
            return nil
        }
        _ = self.onceTracker
        guard let bundle = self.bundle else {
            return nil
        }
        let image = UIImage(named: named, in: bundle, compatibleWith: nil)
        return image
    }
}
