//
//  DependencyContainer.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class DependencyContainer {
    fileprivate lazy var networkAdapter: SteamAPINetworkAdapterProtocol & Dota2APINetworkAdapterProtocol = SteamAPINetworkAdapter()
    fileprivate lazy var profileRouter: ProfileRouterProtocol = ProfileRouter(container: self)
}

extension DependencyContainer: ViewModelFactory {
    func makeProfileViewModel(state: ProfileViewModel.State) -> ProfileViewModel {
        return ProfileViewModel(networkAdapter: networkAdapter, state: state)
    }
    
    func makeSessionsViewModel() -> SessionsViewModel {
        return SessionsViewModel(networkAdapter: networkAdapter)
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel()
    }
    
    func makeAnyGameStatsViewModel(gameId: Int, steamId: String) -> GameStatsViewModel {
        return GameStatsViewModel(networkAdapter: networkAdapter, gameId: gameId, steamId: steamId)
    }
    
    func makeDota2StatsViewModel(steamId: String) -> Dota2StatsViewModel {
        return Dota2StatsViewModel(networkAdapter: networkAdapter, steamId: steamId)
    }
    
    
}

extension DependencyContainer: ViewControllerFactory {
    func makeLoginVC() -> LoginViewController {
        return LoginViewController()
    }
    
    func makeProfileVC(state: ProfileViewModel.State) -> ProfileViewController {
        let viewModel = makeProfileViewModel(state: state)
        return ProfileViewController(viewModel: viewModel, router: profileRouter)
    }
    
    func makeSessionsVC() -> SessionsViewController {
        let viewModel = makeSessionsViewModel()
        return SessionsViewController(viewModel: viewModel)
    }
    
    func makeSettingsVC() -> SettingsViewController {
        let viewModel = makeSettingsViewModel()
        return SettingsViewController(viewModel: viewModel)
    }
    
    func makeAnyGameStatsVC(gameId: Int, steamId: String) -> GameStatsViewController {
        let viewModel = makeAnyGameStatsViewModel(gameId: gameId, steamId: steamId)
        return GameStatsViewController(viewModel: viewModel)
    }
    
    func makeDota2StatsVC(steamId: String) -> Dota2StatsViewController {
        let viewModel = makeDota2StatsViewModel(steamId: steamId)
        return Dota2StatsViewController(viewModel: viewModel)
    }
}