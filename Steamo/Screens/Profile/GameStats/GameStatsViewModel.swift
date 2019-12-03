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
    
    private let networkAdapter: SteamAPINetworkAdapterProtocol
    
    private let gameId: Int
    private let steamId: String
    
    private var gameSchema: GameSchema? = nil
    private var userStats: PlayerStats? = nil
    
    init(networkAdapter: SteamAPINetworkAdapterProtocol,
         gameId: Int,
         steamId: String) {
        self.networkAdapter = networkAdapter
        self.gameId = gameId
        self.steamId = steamId
    }
    
    /// Загрузить данные, добавить секции
    /// - Parameter completion: колбэк по окончанию запроса
    func load(completion: @escaping (Result<Void, SteamoError>) -> Void) {
        
        let chainDispatchGroup = DispatchGroup()
        
        chainDispatchGroup.enter()
        networkAdapter.gameSchema(for: gameId) { result in
            switch result {
            case let .success(schema):
                self.gameSchema = schema
                chainDispatchGroup.leave()
            case let .failure(error):
                print(error)
                chainDispatchGroup.leave()
            }
        }
        
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
        
        chainDispatchGroup.notify(queue: .main, work: workItem)
    }
    
    /// Добавить новые секции, если есть или показать заглушку
    /// - Parameter stats: статистика и ачивки
    private func handleNew(_ stats: (PlayerStats)) {
        let playerStatsSectionViewModel = PlayerStatsSectionViewModel(stats: stats, gameSchema: self.gameSchema)
        let playerAchievementsSectionViewModel = PlayerAchievementsSectionViewModel(stats: stats, gameSchema: self.gameSchema)
       
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
    
    /// Добавить заглушку
    private func handleError() {
        sectionViewModels = []
        let errorSection = StatsErrorSectionViewModel()
        sectionViewModels.append(errorSection)
    }
    
}
