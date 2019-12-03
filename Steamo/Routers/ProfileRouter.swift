//
//  ProfileRouter.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

protocol ProfileRouterProtocol {
    /// Модально показать вебвью авторизации
    /// - Parameters:
    ///   - vc: контроллер, с которого презентим
    ///   - completion: блок по завершению авторизации
    func routeToLogin(from vc: UIViewController, completion: @escaping (SteamUser) -> Void)
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
    
    /// Перейти на детальную статистику по доте
    /// - Parameters:
    ///   - vc: контроллер, с которого пушим
    ///   - steamId: стим айди игрока
    func routeToDota2Stats(from vc: UIViewController, steamId: String)
}

class ProfileRouter: ProfileRouterProtocol {
    
    weak var container: DependencyContainer?
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func routeToLogin(from vc: UIViewController, completion: @escaping (SteamUser) -> Void) {
        guard let loginVC = container?.makeLoginVC() else {
            return
        }
        
        let navigationLoginVC = loginVC.wrapInNavigation()
        
        loginVC.completion = completion
        
        vc.present(navigationLoginVC, animated: true, completion: nil)
    }
    
    func routeToDota2Stats(from vc: UIViewController, steamId: String) {
        guard let dota2StatsVC = container?.makeDota2StatsVC(steamId: steamId) else {
            return
        }
        vc.navigationController?.pushViewController(dota2StatsVC, animated: true)
    }
    
    func routeToFriendProfile(from vc: UIViewController, steamId: String) {
        guard let friendProfileVC = container?.makeProfileVC(state: .friend(steamId: steamId)) else {
            return
        }
        vc.navigationController?.pushViewController(friendProfileVC, animated: true)
    }
    
    func routeToGameStats(from vc: UIViewController, steamId: String, gameId: Int) {
        guard let gameStatsVC = container?.makeAnyGameStatsVC(gameId: gameId, steamId: steamId) else {
            return
        }
        vc.navigationController?.pushViewController(gameStatsVC, animated: true)
    }
}
