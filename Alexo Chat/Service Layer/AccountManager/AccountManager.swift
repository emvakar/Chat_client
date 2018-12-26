//
//  AccountManager.swift
//  alexo
//
//  Created by Emil Karimov on 31.08.2018.
//  Copyright © 2018 ESKARIA Corporation. All rights reserved.
//

import Foundation

struct DefaultsKeys {
    static let app_token = "com.eskaria.alexo.app.token"
    static let user_token = "com.eskaria.alexo.user.token"
    static let refresh_token = "com.eskaria.alexo.user.refresh.token"
    static let bearer_token = "com.eskaria.alexo.user.refresh.bearer.token"
    static let user_id = "com.eskaria.alexo.user.refresh.chat.userid"
    static let user_nickname = "com.eskaria.alexo.user.refresh.chat.nickname"
}

enum Environmet {
    case develop
    case production
    case local
}

enum GrantType: String {
    case credentials = "client_credentials"
    case password = "password"
}

class AccountManager {

    var environmet: Environmet

    let clientId: String = "alexo_mobile_client"
    let client_secret: String = "75DE815DDC61AB45A5C5C93EF7D9D"

    let appName: String = "alexo_mobile_user"
    let appPassword: String = "38EAAC5D4BF31F5AF846DCEC9D064"

    var isNeedUseAuth: Bool = false

    let defaults = UserDefaults.standard

    init(environmet: Environmet) {
        self.environmet = environmet
    }

}

// MARK: - Get constants
extension AccountManager {

    func getBaseUrl() -> String {
        switch environmet {
        case .develop: return "http://192.168.100.2:8080"
        case .production: return "http://192.168.100.2:8080"
        case .local: return "http://192.168.100.2:8080"
        }
    }

    func getAppToken() -> String {
        return defaults.string(forKey: DefaultsKeys.app_token) ?? ""
    }

    func setAppToken(newToken: String) {
        defaults.set(newToken, forKey: DefaultsKeys.app_token)
    }

    func getUserToken() -> String {
        return defaults.string(forKey: DefaultsKeys.user_token) ?? ""
    }

    func setUserToken(newToken: String) {
        defaults.set(newToken, forKey: DefaultsKeys.user_token)
    }

    func getRefreshToken() -> String {
        return defaults.string(forKey: DefaultsKeys.refresh_token) ?? ""
    }

    func setRefreshToken(newToken: String) {
        defaults.set(newToken, forKey: DefaultsKeys.refresh_token)
    }

    func refreshBearerToken(token: String) {
        defaults.set(token, forKey: DefaultsKeys.bearer_token)
    }

    func getBearerToken() -> String {
        return defaults.string(forKey: DefaultsKeys.bearer_token) ?? ""
    }

    func setUserId(userId: String) {
        defaults.set(userId, forKey: DefaultsKeys.user_id)
    }

    func getUserId() -> String {
        return defaults.string(forKey: DefaultsKeys.user_id) ?? ""
    }

    func setUsername(nickname: String) {
        defaults.set(nickname, forKey: DefaultsKeys.user_nickname)
    }

    func getUsername() -> String {
        return defaults.string(forKey: DefaultsKeys.user_nickname) ?? ""
    }
}
