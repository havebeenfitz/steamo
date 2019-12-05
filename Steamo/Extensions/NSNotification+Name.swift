//
//  NSNotification.swift
//  Steamo
//
//  Created by Max Kraev on 29.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static var DidLogin: Notification.Name {
        return Notification.Name("DidLogin")
    }
    
    static var WillLogout: Notification.Name {
        return Notification.Name("WillLogout")
    }
    
    static var DidLogout: Notification.Name {
        return Notification.Name("DidLogout")
    }
}
