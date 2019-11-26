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
        let networkAdapter = NetworkAdapter()
        let profileViewModel = ProfileViewModel(networkAdapter: networkAdapter)
        let profileVC = ProfileViewController(viewModel: profileViewModel)
                                .wrapInNavigation(tabBarStyle: TabBarStyle(title: "Profile",
                                                                           icon: UIImage(named: "profile")))
        
        let sessionsViewModel = SessionsViewModel(networkAdapter: networkAdapter)
        let sessionsVC = SessionsViewController(viewModel: sessionsViewModel)
                                .wrapInNavigation(tabBarStyle: TabBarStyle(title: "Sessions",
                                                                           icon: UIImage(named: "session")))
        
        viewControllers = [profileVC, sessionsVC]
    }

}

