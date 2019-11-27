//
//  UIColor+Appcolor.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

/// iOS 10 support
extension UIColor {
    
    class var text: UIColor {
        return UIColor(red: 40 / 255, green: 33 / 255, blue: 32 / 255, alpha: 1)
    }
    
    class var background: UIColor {
        return UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
    }
    
    class var accent: UIColor {
        return UIColor(red: 4 / 255, green: 31 / 255, blue: 96 / 255, alpha: 1)
    }
    
    class var hud: UIColor {
        return UIColor(red: 235 / 255, green: 235 / 255, blue: 235 / 255, alpha: 0.8)
    }
}
