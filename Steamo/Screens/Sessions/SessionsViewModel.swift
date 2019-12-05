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
    
    private var gamesResponse: Games?
    private var games: [Game] = []
    
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
    /// - Parameters:
    ///   - force: нужно ли ходить в интернет. Сходим в любом случае, если в базе пусто
    ///   - completion: блок по завершению запроса
    func load(force: Bool, completion: @escaping ((Swift.Result<Void, SteamoError>) -> Void)) {
        guard let steamId = steamId else {
            sectionViewModels = [NoSessionsSectionViewModel()]
            completion(.failure(.noData))
            return
        }
        
        sectionViewModels = []
        
        let games: [Game] = databaseManager.load(filter: nil)
        if !games.isEmpty {
            self.appendSections(with: games)
            completion(.success(()))
        } else {
            loadFromInternet(for: steamId, completion: completion)
        }
        
        if force {
            loadFromInternet(for: steamId, completion: completion)
        }
    }
    
    /// Очистить вьюмодель и базу от данных. Используется при разлогине
    func erase() {
        let games: [Game] = databaseManager.load(filter: { $0.ownerSteamId == self.steamId })
        databaseManager.delete(games)
        self.sectionViewModels = []
        self.games = []
    }
    
    private func loadFromInternet(for steamId: String, completion: @escaping ((Swift.Result<Void, SteamoError>) -> Void)) {
        networkAdapter.recentlyPlayedGames(steamId: steamId) { [weak self] result in
            switch result {
            case let .success(gamesResponse):
                self?.games.append(contentsOf: gamesResponse.response?.games ?? [])
                let dbGames = gamesResponse.response?.games?.map { game -> Game in
                    // Преобразуем к реалмовскому виду
                    // NB! Т.к. appId может быть одинковым для разных игроков, нужен другой primaryKey
                    // При этом нам нужно цеплять уже созданный uuid от игры, которая в базе, чтобы произошел апдейт
                    if let game: Game = self?.databaseManager.load(filter: { $0.appId == game.appId }).first {
                        return Game(ownerSteamId: steamId, createdAt: Date().timeIntervalSince1970, game: game)
                    }
                    return Game(ownerSteamId: steamId, createdAt: Date().timeIntervalSince1970, game: game)
                }
                self?.save(dbGames ?? [])
                self?.appendSections(with: dbGames ?? [])
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func save(_ games: [Game]) {
        databaseManager.save(games, shouldUpdate: true)
    }
    
    private func appendSections(with games: [Game]) {
        guard !games.isEmpty else {
            sectionViewModels.append(NoSessionsSectionViewModel())
            return
        }
        
        let twoWeeksSessions = games.filter { !$0.isOlderThan2Weeks }
        let olderSessions = games.filter { $0.isOlderThan2Weeks }
            .map { game -> Game in
                // Затираем последний плэйтайм в случае, если прошло больше двух недель
                let game = Game(playtime2Weeks: nil, game: game)
                self.databaseManager.save(game, shouldUpdate: true)
                return game
            }
        
        let twoWeeksSection = TwoWeekSessionsSectionViewModel(games: twoWeeksSessions)
        let olderSection = OlderSessionsSectionViewModel(games: olderSessions)
        
        // Если загрузили с форсом, то нужно обновить первую секцию
        // На этот момент в реалме уже появились обновленные объекты с ненулевым playtime2Weeks
        // При этом заботимся о том, чтобы не потерять сессии из базы, если они по каким-то причинам пропали из выдачи раньше, чем через 2 недели
        if !twoWeeksSessions.isEmpty, !sectionViewModels.isEmpty {
            let previousTwoWeeksSessions: [Game] = self.databaseManager.load(filter: { !$0.isOlderThan2Weeks })
            let previous2WeeksSessionsSet = Set(previousTwoWeeksSessions)
            let loaded2WeeksSessionsSet = Set(twoWeeksSessions)
            let subtraction = previous2WeeksSessionsSet.subtracting(loaded2WeeksSessionsSet)
            
            // Если после вычитания что-то осталось, то сессии пропали из выдачи раньше, чем через 2 недели
            // Кроме того, можно добавлять объекты в Realm Studio, они нормально отобразятся
            if !subtraction.isEmpty {
                sectionViewModels.remove(at: 0)
                sectionViewModels.insert(TwoWeekSessionsSectionViewModel(games: twoWeeksSessions + Array(subtraction)), at: 0)
            } else {
                sectionViewModels.remove(at: 0)
                sectionViewModels.insert(twoWeeksSection, at: 0)
            }
            
        } else {
            sectionViewModels.append(twoWeeksSection)
        }
        
        if !olderSessions.isEmpty {
             sectionViewModels.append(olderSection)
        }
       
        if twoWeeksSessions.isEmpty, olderSessions.isEmpty {
            let noSessionsViewModel = NoSessionsSectionViewModel()
            sectionViewModels.append(noSessionsViewModel)
        }
    }
}
