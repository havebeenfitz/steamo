//
//  ViewController.swift
//  Steamo
//
//  Created by Max Kraev on 20.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
    }

    private func addViewControllers() {
        let profileVC = container.makeProfileVC(state: .you)
                                 .wrapInNavigation(tabBarStyle: TabBarStyle(title: "Profile",
                                                                            icon: UIImage(named: "profile")))

        let sessionsVC = container.makeSessionsVC()
                                  .wrapInNavigation(tabBarStyle: TabBarStyle(title: "Sessions",
                                                                             icon: UIImage(named: "session")))

        let settingsVC = container.makeSettingsVC()
                                  .wrapInNavigation(tabBarStyle: TabBarStyle(title: "Settings",
                                                                             icon: UIImage(named: "settings")))

        viewControllers = [profileVC, sessionsVC, settingsVC]
    }
}
