//
//  ViewModelFactory.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

protocol ViewModelFactory {
    func makeProfileViewModel(state: ProfileViewModel.State) -> ProfileViewModel
    func makeSessionsViewModel() -> SessionsViewModel
    func makeSettingsViewModel() -> SettingsViewModel
    
    func makeAnyGameStatsViewModel(gameId: Int, gameName: String, steamId: String) -> GameStatsViewModel
    func makeDota2StatsViewModel(steamId: String) -> Dota2StatsViewModel
}
