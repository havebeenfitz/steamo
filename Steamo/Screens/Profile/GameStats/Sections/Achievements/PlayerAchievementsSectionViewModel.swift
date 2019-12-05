//
//  PlayerAchievementsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class PlayerAchievementsSectionViewModel: StatsSectionViewModelRepresentable {
    var type: StatsSectionViewModelType {
        return .playerAchievements
    }
    
    var rowCount: Int {
        return gameSchema?.game.availableGameStats?.achievements?.count ?? 0
    }
    
    var sectionTitle: String {
        return "Achievements"
    }
    
    var stats: PlayerStats
    var gameSchema: GameSchema?
    
    init(stats: PlayerStats, gameSchema: GameSchema?) {
        self.stats = stats
        self.gameSchema = gameSchema
    }
    
    /// Найти название ачивки по схеме игры
    /// - Parameter index: индекс
    func achievementDisplayName(at index: Int) -> String {
        let schemeAch = gameSchema?.game.availableGameStats?.achievements?[safe: index]
        return schemeAch?.displayName ?? schemeAch?.name ?? "No achievemnt name"
    }
    
    func achievementDescription(at index: Int) -> String {
        let schemeAch = gameSchema?.game.availableGameStats?.achievements?[safe: index]
        return schemeAch?.description ?? ""
    }
    
    /// Найти картинку ачивки по схеме игры
    /// Если ачивка не достигнута, то картинка будет серой
    ///
    /// - Parameter index: индекс
    func achievementLogoPath(at index: Int) -> String {
        let playerAchievements = stats.playerStats?.achievements ?? []
        let allAchievements = gameSchema?.game.availableGameStats?.achievements
        
        let schemeAch = allAchievements?[safe: index]
    
        let matchedAch = playerAchievements.first(where: { $0.name == schemeAch?.name })
        
        return (matchedAch?.achieved == 1 ? schemeAch?.icon : schemeAch?.iconGray) ?? ""
    }
}
