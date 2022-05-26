//
//  AppDelegate.swift
//  FoodCompositRealmSample
//
//  Created by toaster on 2022/01/25.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        
        let config = Realm.Configuration(
            schemaVersion: 12,
            migrationBlock: { migration, oldSchemaVersion in})
        Realm.Configuration.defaultConfiguration = config
        let realm = FoodTabelRepositoryImpr()
        realm.initializeRealm()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
