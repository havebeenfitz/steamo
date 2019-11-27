//
//  ViewController.swift
//  Steamo
//
//  Created by Max Kraev on 20.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        addViewControllers()
    }
    
    private func setupAppearence() {
        tabBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            tabBar.tintColor = UIColor(named: "Accent")
            tabBar.barTintColor = UIColor(named: "Background")
        } else {
            tabBar.tintColor = .accent
            tabBar.barTintColor = .background
        }
    }
    
    private func addViewControllers() {
        let networkAdapter = SteamAPINetworkAdapter()
        let router = ProfileRouter()
        let profileViewModel = ProfileViewModel(networkAdapter: networkAdapter,
                                                state: .you)
        let profileVC = ProfileViewController(viewModel: profileViewModel,
                                              router: router)
                                .wrapInNavigation(tabBarStyle: TabBarStyle(title: "Profile",
                                                                           icon: UIImage(named: "profile")))
        
        let sessionsViewModel = SessionsViewModel(networkAdapter: networkAdapter)
        let sessionsVC = SessionsViewController(viewModel: sessionsViewModel)
                                .wrapInNavigation(tabBarStyle: TabBarStyle(title: "Sessions",
                                                                           icon: UIImage(named: "session")))
        
        let settingsViewModel = SettingsViewModel()
        let settingsVC = SettingsViewController(viewModel: settingsViewModel)
                            .wrapInNavigation(tabBarStyle: TabBarStyle(title: "Settings",
                                                                       icon: UIImage(named: "settings")))
        
        viewControllers = [profileVC, sessionsVC, settingsVC]
    }

}

