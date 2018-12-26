//
//  Extensions.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 26/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation
import UIKit

extension Double {

    func roundWithPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

extension String: Error { }

extension String {

    var data: Data { return Data(utf8) }
    var base64Encoded: Data { return data.base64EncodedData() }
    var base64Decoded: Data? { return Data(base64Encoded: self) }

    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }

        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }

}

extension Data {
    var string: String? { return String(data: self, encoding: .utf8) }
}
