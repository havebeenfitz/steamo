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
        return achievementSchemas.count
    }
    
    var sectionTitle: String {
        return "Achievements"
    }
    
    private var ownerSteamId: String
    private var gameId: Int
    private var achievementSchemas: [AchievementSchema] = []
    private var playerAchievements: [PlayerAchievement] = []
    private var databaseManager: DatabaseManagerProtocol
    
    
    init(ownerSteamId: String, gameId: Int, databaseManager: DatabaseManagerProtocol) {
        self.ownerSteamId = ownerSteamId
        self.gameId = gameId
        self.databaseManager = databaseManager
        updateFromDatabase()
    }
    
    /// Найти название ачивки по схеме игры
    /// - Parameter index: индекс
    func achievementDisplayName(at index: Int) -> String {
        let achScheme = achievementSchemas[safe: index]
        return achScheme?.displayName ?? achScheme?.name ?? "No achievemnt name"
    }
    
    func achievementDescription(at index: Int) -> String {
        let achScheme = achievementSchemas[safe: index]
        return achScheme?.descriptionValue ?? ""
    }
    
    /// Найти картинку ачивки по схеме игры
    /// Если ачивка не достигнута, то картинка будет серой
    ///
    /// - Parameter index: индекс
    func achievementLogoPath(at index: Int) -> String {
        let schemeAch = achievementSchemas[safe: index]
        let matchedAch = playerAchievements.first(where: { $0.name == schemeAch?.name })
        
        return (matchedAch?.achieved == 1 ? schemeAch?.icon : schemeAch?.iconGray) ?? ""
    }
    
    private func updateFromDatabase() {
        let achSchemas: [AchievementSchema] = databaseManager.load(filter: { $0.gameId.value == self.gameId })
        self.achievementSchemas = achSchemas
        
        let playerAchievements: [PlayerAchievement] = databaseManager.load(filter: { $0.gameId.value == self.gameId && $0.ownerSteamId == self.ownerSteamId })
        
        let strippedPlayerAches: [PlayerAchievement] = playerAchievements.reduce(into: []) { result, ach in
            if result.contains(where: { $0.name == ach.name }) && ach.achieved == 1 {
                return
            } else {
                result.append(ach)
            }
        }
        
        self.playerAchievements = strippedPlayerAches
    }
}
