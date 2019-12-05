//
//  SessionsViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SessionsViewModel: NSObject {
    
    var games: [Game] = []
    
    private let databaseManager: DatabaseManagerProtocol
    private let networkAdapter: SteamAPINetworkAdapterProtocol

    private var gamesResponse: Games?

    private var steamId: String? {
        let user = SteamUser.fetch()
        return user?.steamID64
    }

    init(databaseManager: DatabaseManagerProtocol, networkAdapter: SteamAPINetworkAdapterProtocol) {
        self.databaseManager = databaseManager
        self.networkAdapter = networkAdapter
    }

    func load(completion: @escaping ((Swift.Result<Void, SteamoError>) -> Void)) {
        let games: [Game] = databaseManager.load(filter: nil)
        if !games.isEmpty {
            self.games.append(contentsOf: games)
            completion(.success(()))
            return
        }
        
        networkAdapter.recentlyPlayedGames(steamId: steamId ?? "noSteamId") { [weak self] result in
            switch result {
            case let .success(gamesResponse):
                self?.games.append(contentsOf: gamesResponse.response?.games ?? [])
                self?.save(gamesResponse.response?.games ?? [])
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func save(_ games: [Game]) {
        databaseManager.save(games, shouldUpdate: true)
    }
}
