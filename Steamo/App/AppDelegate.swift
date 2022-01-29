//
//  AppDelegate.swift
//  Steamo
//
//  Created by Max Kraev on 20.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import ProgressHUD
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureHUD()
        
        let container = DependencyContainer()
        
        // Миграция для реалма, если нужна
        container.databaseManager.migrate(with: 0)

        return true
    }

    private func configureHUD() {
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.colorBackground = .background
        ProgressHUD.colorHUD = .hud
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
