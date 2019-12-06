//
//  SettingsViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    private let databaseManager: DatabaseManagerProtocol
    
    init(databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
    }
    
    func logout() {
        NotificationCenter.default.post(name: .WillLogout, object: nil)
        SteamUser.remove()
        NotificationCenter.default.post(name: .DidLogout, object: nil)
    }
    
    func eraseAll() {
        NotificationCenter.default.post(name: .WillEraseAllData, object: nil)
        databaseManager.eraseAll()
        NotificationCenter.default.post(name: .DidEraseAllData, object: nil)
    }
}
