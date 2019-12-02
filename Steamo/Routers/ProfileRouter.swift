//
//  ProfileRouter.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

protocol ProfileRouterProtocol {
    /// Перейти на профиль друга
    /// - Parameters:
    ///   - vc: контроллер, с которого пушим
    ///   - steamId: Стим айди друга
    func routeToFriendProfile(from vc: UIViewController, steamId: String)
    /// Перейти на упрощенную статистику по игре
    /// - Parameters:
    ///   - vc: контроллер, с которого пушим
    ///   - steamId: стим айди игрока
    ///   - gameId: идентификатор игры
    func routeToGameStats(from vc: UIViewController, steamId: String, gameId: Int)
}

class ProfileRouter: ProfileRouterProtocol {
    func routeToFriendProfile(from vc: UIViewController, steamId: String) {
        let profileViewModel = ProfileViewModel(networkAdapter: SteamAPINetworkAdapter(),
                                                state: .friend(steamId: steamId))
        let friendProfileVC = ProfileViewController(viewModel: profileViewModel,
                                                    router: self)
        vc.navigationController?.pushViewController(friendProfileVC, animated: true)
    }
    
    func routeToGameStats(from vc: UIViewController, steamId: String, gameId: Int) {
        let gameStatsViewModel = GameStatsViewModel(networkAdapter: SteamAPINetworkAdapter(),
                                                    gameId: gameId,
                                                    steamId: steamId)
        let gameStatsVC = GameStatsViewController(viewModel: gameStatsViewModel)
        vc.navigationController?.pushViewController(gameStatsVC, animated: true)
    }
}
