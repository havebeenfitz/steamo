//
//  Dota2StatsViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class Dota2StatsViewModel {
    
    private let networkAdapter: SteamAPINetworkAdapterProtocol
    private let steamId: String
    
    init(networkAdapter: SteamAPINetworkAdapterProtocol, steamId: String) {
        self.networkAdapter = networkAdapter
        self.steamId = steamId
    }
    
    
}
