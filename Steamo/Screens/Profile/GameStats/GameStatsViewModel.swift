//
//  GameStatsViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class GameStatsViewModel {
    
    var sectionViewModels: [StatsSectionViewModelRepresentable] = []
    
    private let databaseManager: DatabaseManagerProtocol
    private let networkAdapter: SteamAPINetworkAdapterProtocol
    
    private let gameId: Int
    private let gameName: String
    private let steamId: String
    
    private var gameSchema: GameSchema? = nil
    private var userStats: PlayerStats? = nil
    
    init(databaseManager: DatabaseManagerProtocol,
         networkAdapter: SteamAPINetworkAdapterProtocol,
         gameId: Int,
         gameName: String,
         steamId: String) {
        self.databaseManager = databaseManager
        self.networkAdapter = networkAdapter
        self.gameId = gameId
        self.gameName = gameName
        self.steamId = steamId
    }
    
    func screenTitle() -> String {
        return gameName
    }
    
    /// Загрузить данные, добавить секции
    /// - Parameter completion: колбэк по окончанию запроса
    func load(force: Bool, completion: @escaping (Result<Void, SteamoError>) -> Void) {
        
        let statSchemas: [StatSchema] = databaseManager.load(filter: { $0.gameId.value == self.gameId })
    
        let chainDispatchGroup = DispatchGroup()
        let workItem = DispatchWorkItem {
            self.networkAdapter.stats(for: self.gameId, steamId: self.steamId) { [weak self] result in
                switch result {
                case let .success(stats):
                    self?.handleNew(stats)
                    completion(.success(()))
                case let .failure(error):
                    self?.handleError()
                    completion(.failure(error))
                }
            }
       }
        
        
        if !statSchemas.isEmpty {
            DispatchQueue.global().async {
                workItem.perform()
            }
            return
        }
        
        chainDispatchGroup.enter()
        networkAdapter.gameSchema(for: gameId) { [weak self] result in
            switch result {
            case let .success(schema):
                self?.gameSchema = schema
                self?.handleNew(schema)
                chainDispatchGroup.leave()
            case let .failure(error):
                print(error)
                chainDispatchGroup.leave()
            }
        }
        
        chainDispatchGroup.notify(queue: .main, work: workItem)
    }
    
    private func handleNew(_ schema: GameSchema) {
        if let statSchemas: [StatSchema] = schema.game.availableGameStats?.stats {
            let dbStatSchemas = statSchemas.map { statSchema -> StatSchema in
                return StatSchema(gameId: self.gameId, stat: statSchema)
            }
            databaseManager.save(dbStatSchemas, shouldUpdate: true)
        }
        
        if let achievementSchemas: [AchievementSchema] = schema.game.availableGameStats?.achievements {
            let dbAchSchemas = achievementSchemas.map { achSchema  -> AchievementSchema in
                return AchievementSchema(gameId: self.gameId, achievementSchema: achSchema)
            }
            databaseManager.save(dbAchSchemas, shouldUpdate: true)
        }
    }
    
    /// Добавить новые секции, если есть или показать заглушку
    /// - Parameter stats: статистика и ачивки
    private func handleNew(_ stats: PlayerStats) {
        savePlayerStats(stats)
        savePlayerAchievements(stats)
        
        let playerStatsSectionViewModel = PlayerStatsSectionViewModel(ownerSteamId: steamId, gameId: gameId, databaseManager: databaseManager)
        let playerAchievementsSectionViewModel = PlayerAchievementsSectionViewModel(ownerSteamId: steamId, gameId: gameId, databaseManager: databaseManager)
       
        let isPlayerStatsAvailable = !(stats.playerStats?.stats?.isEmpty ?? true)
        let isPlayerAchievementsAvaliable = !(stats.playerStats?.achievements?.isEmpty ?? true)
        
        guard isPlayerStatsAvailable || isPlayerAchievementsAvaliable else {
            handleError()
            return
        }
       
        if isPlayerStatsAvailable {
            sectionViewModels.append(playerStatsSectionViewModel)
        } else {
            sectionViewModels.append(NoPlayerStatsSectionViewModel())
        }
       
        if isPlayerAchievementsAvaliable {
            sectionViewModels.append(playerAchievementsSectionViewModel)
        } else {
            sectionViewModels.append(NoPlayerAchievementsSectionViewModel())
        }
    }
    
    private func savePlayerStats(_ stats: PlayerStats) {
        if let playerStats = stats.playerStats?.stats {
            let dbPlayerStats = playerStats.map { stat -> PlayerStat in
                let statSchemas: [StatSchema] = databaseManager.load(filter: { $0.gameId.value == self.gameId })
                let displayName: String = statSchemas.first(where: { $0.name == stat.name })?.displayName ?? stat.name
                let createdAt = Date().timeIntervalSince1970
                return PlayerStat(gameId: self.gameId, createdAt: createdAt, ownerSteamId: self.steamId, displayName: displayName, stat: stat)
            }
            databaseManager.save(dbPlayerStats, shouldUpdate: true)
        }
    }
    
    private func savePlayerAchievements(_ stats: PlayerStats) {
        if let playerAchievements = stats.playerStats?.achievements {
            let dbPlayerAchievements = playerAchievements.map { ach -> PlayerAchievement in
                return PlayerAchievement(gameId: self.gameId, ownerSteamId: self.steamId, achievement: ach)
            }
            databaseManager.save(dbPlayerAchievements, shouldUpdate: true)
        }
    }
    
    /// Добавить заглушку
    private func handleError() {
        sectionViewModels = []
        let errorSection = StatsErrorSectionViewModel()
        sectionViewModels.append(errorSection)
    }
    
}
