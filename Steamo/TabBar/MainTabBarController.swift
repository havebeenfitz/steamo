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
        let profileViewModel = ProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileViewModel).wrapInNavigation(tabBarStyle: TabBarStyle(title: "Profile",
                                                                                                                     icon: UIImage(named: "profile")))
        let stubVC1 = UIViewController().wrapInNavigation(tabBarStyle: TabBarStyle(title: "Games",
                                                                                   icon: nil))
        let stubVC2 = UIViewController().wrapInNavigation(tabBarStyle: TabBarStyle(title: "Stats",
                                                                                   icon: nil))
        viewControllers = [profileVC, stubVC1, stubVC2]
    }

}

