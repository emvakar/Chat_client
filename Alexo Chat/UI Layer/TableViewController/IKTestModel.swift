//
//  IKTestModel.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 22/09/2018
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - TestModel
public class IKTestModel: NSObject {
    public var id: String?

    public override init() {
        super.init()

        self.id = UUID().uuidString
    }
}
