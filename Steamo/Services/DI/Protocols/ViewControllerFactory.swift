//
//  ViewControllerFactory.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

protocol ViewControllerFactory {
    func makeLoginVC() -> LoginViewController
    func makeProfileVC(state: ProfileViewModel.State) -> ProfileViewController
    func makeSessionsVC() -> SessionsViewController
    func makeSettingsVC() -> SettingsViewController
    func makeAnyGameStatsVC(gameId: Int, steamId: String) -> GameStatsViewController
    func makeDota2StatsVC(steamId: String) -> Dota2StatsViewController
}
