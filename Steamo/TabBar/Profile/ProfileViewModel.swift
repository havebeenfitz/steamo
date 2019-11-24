//
//  ProfileViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    var isUserAuthorized: Bool {
        return steamId != nil
    }
    
    /// Стим айди игрока
    var steamId: String? {
        get {
            UserDefaults.standard.string(forKey: SteamoUserDefaultsKeys.steamId)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: SteamoUserDefaultsKeys.steamId)
        }
    }
    
    init() {
        
    }
    
    func logout() {
        steamId = nil
    }
}
