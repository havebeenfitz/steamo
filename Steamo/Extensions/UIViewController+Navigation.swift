//
//  UIViewController+Navigation.swift
//  Steamo
//
//  Created by Max Kraev on 24.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

struct TabBarStyle {
    let title: String
    let icon: UIImage?
}

extension UIViewController {
    func wrapInNavigation(tabBarStyle: TabBarStyle? = nil) -> SteamoNavigationController {
        let isNavigationController = isKind(of: SteamoNavigationController.self) || isKind(of: UINavigationController.self)

        assert(!isNavigationController, "wrapInNavigation вызван у UINavigationController")
        if isNavigationController {
            return self as! SteamoNavigationController
        }

        let navigationController = SteamoNavigationController(rootViewController: self)

        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = false
        }

        if let tabBarStyle = tabBarStyle {
            navigationController.tabBarItem.title = tabBarStyle.title
            navigationController.tabBarItem.image = tabBarStyle.icon
        }

        return navigationController
    }
}
