//
//  PlayerStats.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

// MARK: - PlayerStats
struct PlayerStats: Codable {
    let playerStats: Stats?

    enum CodingKeys: String, CodingKey {
        case playerStats = "playerstats"
    }
}

// MARK: - Playerstats
struct Stats: Codable {
    let steamId: String?
    let gameName: String?
    let stats: [PlayerStat]?
    let achievements: [PlayerAchievement]?

    enum CodingKeys: String, CodingKey {
        case steamId = "steamID"
        case gameName = "gameName"
        case stats = "stats"
        case achievements = "achievements"
    }
}

// MARK: - Achievement
struct PlayerAchievement: Codable, Hashable {
    let name: String
    let achieved: Int
}

// MARK: - Stat
struct PlayerStat: Codable {
    let name: String
    let value: Double
}
