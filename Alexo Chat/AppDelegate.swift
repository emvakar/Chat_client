//
//  AppDelegate.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 25/12/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import UIKit

class StringKeys {
    static let selectedThemeKey = "com.eskaria.alexo.selectedTheme"
}

let websocketManager = WebSocketManager(environmet: .production)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let accountManager = AccountManager(environmet: .production)

    var networkProvider: NetworkRequestProvider! = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
        UINavigationBar.appearance().prefersLargeTitles = true

        let networkWrapper = NetworkRequestWrapper()

        self.networkProvider = NetworkRequestProvider(networkWrapper: networkWrapper, tokenRefresher: nil, accountManager: self.accountManager, websocketManager: websocketManager)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let resolver = DIResolver(networkController: self.networkProvider, accountManager: self.accountManager, webSocketManager: websocketManager)
        if self.accountManager.getBearerToken().isEmpty {
            self.window?.rootViewController = resolver.presentAuthorizationViewController()
        } else {
            self.window?.rootViewController = UINavigationController(rootViewController: resolver.presentRoomListViewController())
        }
        self.window?.makeKeyAndVisible()

        websocketManager.connect()

        return true
    }
}

extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        websocketManager.disconnect()
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        websocketManager.disconnect()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        websocketManager.connect()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {
        websocketManager.disconnect()
    }
}
