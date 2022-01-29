//
//  SessionsViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SessionsViewModel: NSObject {
    /// Вьюмодели секций
    var sectionViewModels: [SessionSectionViewModelRepresentable] = []
    
    private let databaseManager: DatabaseManagerProtocol
    private let networkAdapter: SteamAPINetworkAdapterProtocol

    private var steamId: String? {
        let user = SteamUser.fetch()
        return user?.steamID64
    }

    init(databaseManager: DatabaseManagerProtocol, networkAdapter: SteamAPINetworkAdapterProtocol) {
        self.databaseManager = databaseManager
        self.networkAdapter = networkAdapter
    }
    
    /// Загрузить данные для показа
    ///
    /// - Parameters:
    ///   - completion: блок по завершению запроса
    func load(completion: @escaping ((Swift.Result<Void, SteamoError>) -> Void)) {
        guard let steamId = steamId else {
            sectionViewModels = [NoSessionsSectionViewModel()]
            completion(.failure(.noData))
            return
        }
        
        sectionViewModels = []
        loadFromInternet(for: steamId, completion: completion)
    }
    
    func сlear() {
        self.sectionViewModels = []
        sectionViewModels.append(NoSessionsSectionViewModel())
    }
    
    /// Загрузка последних сессий из сети. Завязываемся на то, что сессия считается старше 2 недель, если ее нет в ответе сервера
    /// Если при загрузке произошла ошибка, то показываем последнее сохраненное состояние
    private func loadFromInternet(for steamId: String, completion: @escaping ((Swift.Result<Void, SteamoError>) -> Void)) {
        networkAdapter.recentlyPlayedGames(steamId: steamId) { [weak self] result in
            switch result {
            case let .success(gamesResponse):
                let dbGames = gamesResponse.response?.games?.map { game -> Game in
                    // Если пришли игры, которые есть в базе, то цепляем их и обновляем время игры
                    if let exisitingGame: Game = self?.databaseManager.load(filter: { $0.appId == game.appId && $0.ownerSteamId == steamId }).first {
                        return Game(ownerSteamId: steamId,
                                    playtimeForever: game.playtimeForever,
                                    playtime2Weeks: game.playtime2Weeks.value,
                                    game: exisitingGame)
                    }
                    return Game(ownerSteamId: steamId,
                                playtimeForever: game.playtimeForever,
                                playtime2Weeks: game.playtime2Weeks.value,
                                game: game)
                }
                self?.appendSections(for: steamId, with: dbGames ?? [])
                completion(.success(()))
            case let .failure(error):
                let recentDBSections: [Game] = self?.databaseManager.load(filter: { $0.ownerSteamId == steamId && $0.playtime2Weeks.value != nil}) ?? []
                self?.appendSections(for: steamId, with: recentDBSections)
                completion(.failure(error))
            }
        }
    }
    
    private func appendSections(for steamId: String, with newSessions: [Game]) {
        databaseManager.save(newSessions, shouldUpdate: true)
        let potentiallyOldSessionsSet: Set<Game> = Set(databaseManager.load(filter: { $0.ownerSteamId == steamId &&
                                                                                      $0.playtime2Weeks.value != nil }))
        let newSessionsSet = Set(newSessions)
        let oldSessionsToConvert = Array(potentiallyOldSessionsSet.subtracting(newSessionsSet))
        
//        if !newSessions.isEmpty {
//            sectionViewModels.append(TwoWeekSessionsSectionViewModel(games: newSessions))
//        } else {
//            sectionViewModels.append(NoRecentSessionsSectionViewModel())
//        }
        
        if !oldSessionsToConvert.isEmpty {
            convertToOld(oldSessionsToConvert)
        }
        
        let reallyOldSessions: [Game] = databaseManager.load(filter: { $0.ownerSteamId == steamId && $0.playtime2Weeks.value == nil })
        if !reallyOldSessions.isEmpty {
            sectionViewModels.append(OlderSessionsSectionViewModel(games: reallyOldSessions))
        }
        
        sectionViewModels.sort(by: { $0.index < $1.index })
    }
    
    private func convertToOld(_ games: [Game]) {
        let olderSessions = games.map { game -> Game in
            return Game(playtime2Weeks: nil, game: game)
        }
        databaseManager.save(olderSessions, shouldUpdate: true)
    }
}
