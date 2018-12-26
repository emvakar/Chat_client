//
//  DIResolver.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 11.09.2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

// MARK: - DIResolver
class DIResolver {

    let networkController: NetworkRequestProvider
    let accountManager: AccountManager

    // MARK: - Init
    init(networkController: NetworkRequestProvider, accountManager: AccountManager) {
        self.networkController = networkController
        self.accountManager = accountManager
    }
}
