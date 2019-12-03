//
//  SessionsViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class SessionsViewModel: NSObject {
    private let networkAdapter: SteamAPINetworkAdapterProtocol

    var games: Games?

    private var steamId: String? {
        let user = SteamUser.fetch()
        return user?.steamID64
    }

    init(networkAdapter: SteamAPINetworkAdapterProtocol) {
        self.networkAdapter = networkAdapter
    }

    func loadRecentlyPlayedGames(completion: @escaping ((Swift.Result<Void, SteamoError>) -> Void)) {
        networkAdapter.recentlyPlayedGames(steamId: steamId ?? "noSteamId") { [weak self] result in
            switch result {
            case let .success(games):
                self?.games = games
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
