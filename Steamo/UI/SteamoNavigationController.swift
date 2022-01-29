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
    }

    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
