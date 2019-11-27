//
//  AppDelegate.swift
//  Steamo
//
//  Created by Max Kraev on 20.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureHUD()
        
        if #available(iOS 13.0, *) {} else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = MainTabBarController()
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    private func configureHUD() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setCornerRadius(5)
        SVProgressHUD.setRingRadius(5)
        SVProgressHUD.setRingNoTextRadius(5)
        
        
        let backgoundColor: UIColor
        
        if #available(iOS 11.0, *) {
            backgoundColor = UIColor(named: "Hud") ?? UIColor.background
        } else {
            backgoundColor = .background
        }
        
        SVProgressHUD.setBackgroundColor(backgoundColor)
        
        let foregroundColor: UIColor
        
        if #available(iOS 11.0, *) {
            foregroundColor = UIColor(named: "Text") ?? UIColor.background
        } else {
            foregroundColor = .text
        }
        
        SVProgressHUD.setForegroundColor(foregroundColor)
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}

