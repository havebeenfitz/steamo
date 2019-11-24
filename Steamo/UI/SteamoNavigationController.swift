//
//  SteamoNavigationController.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SteamoNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
    }
    
    private func setupAppearence() {
        navigationBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            navigationBar.barTintColor = UIColor(named: "Background")
        } else {
            navigationBar.barTintColor = .background
        }
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
