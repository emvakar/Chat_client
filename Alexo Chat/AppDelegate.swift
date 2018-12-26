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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let accountManager = AccountManager(environmet: .develop)
    let websocketManager = WebSocketManager(environmet: .develop)

    var networkProvider: NetworkRequestProvider! = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()

        let networkWrapper = NetworkRequestWrapper()

        self.networkProvider = NetworkRequestProvider(networkWrapper: networkWrapper, tokenRefresher: nil, accountManager: self.accountManager, websocketManager: self.websocketManager)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let resolver = DIResolver(networkController: self.networkProvider, accountManager: self.accountManager)
        self.window?.rootViewController = UINavigationController(rootViewController: resolver.presentRoomListViewController())

        self.window?.makeKeyAndVisible()

        self.websocketManager.connect()

        return true
    }
}

extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) { }
    func applicationDidEnterBackground(_ application: UIApplication) { }
    func applicationWillEnterForeground(_ application: UIApplication) { }
    func applicationDidBecomeActive(_ application: UIApplication) { }
    func applicationWillTerminate(_ application: UIApplication) { }
}
