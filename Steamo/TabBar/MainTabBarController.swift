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
        addViewControllers()
    }
    
    private func addViewControllers() {
        let profileVC = ProfileViewController().wrapInNavigation(tabBarStyle: TabBarStyle(title: "Profile", icon: nil))
        let stubVC1 = UIViewController().wrapInNavigation(tabBarStyle: TabBarStyle(title: "Games", icon: nil))
        let stubVC2 = UIViewController().wrapInNavigation(tabBarStyle: TabBarStyle(title: "Stats", icon: nil))
        viewControllers = [profileVC, stubVC1, stubVC2]
    }

}

