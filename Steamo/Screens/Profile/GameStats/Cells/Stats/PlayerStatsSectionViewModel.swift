//
//  UserStatsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class PlayerStatsSectionViewModel: StatsSectionViewModelRepresentable {
    var type: StatsSectionViewModelType {
        return .playerStats
    }
    
    var rowCount: Int {
        return stats.playerStats?.stats?.count ?? 0
    }
    
    var sectionTitle: String {
        return "Stats"
    }
    
    var stats: PlayerStats
    var gameSchema: GameSchema?
    
    init(stats: PlayerStats, gameSchema: GameSchema?) {
        self.stats = stats
        self.gameSchema = gameSchema
    }
    
    func statDisplayName(at index: Int) -> String {
        let allStats = gameSchema?.game.availableGameStats?.stats
        let playerStat = allStats?.first(where: { $0.name == stats.playerStats?.stats?[safe: index]?.name })
        
        let isStatNameAvailable = !(playerStat?.displayName?.isEmpty ?? true)
        
        return (isStatNameAvailable ? playerStat?.displayName : playerStat?.name) ?? "No stat name"
    }
}
