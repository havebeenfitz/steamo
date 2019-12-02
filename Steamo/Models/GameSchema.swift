//
//  GameSchema.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

// MARK: - GameSchema
struct GameSchema: Codable {
    let game: GameStats
}

// MARK: - Game
struct GameStats: Codable {
    let gameName: String?
    let gameVersion: String?
    let availableGameStats: AvailableGameStats?
}

// MARK: - AvailableGameStats
struct AvailableGameStats: Codable {
    let stats: [Stat]?
    let achievements: [Achievement]?
}

// MARK: - Achievement
struct Achievement: Codable, Hashable {
    let name: String
    let defaultValue: Int
    let displayName: String?
    let hidden: Int
    let description: String?
    let icon: String
    let iconGray: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case defaultValue = "defaultvalue"
        case displayName = "displayName"
        case hidden = "hidden"
        case description = "description"
        case icon = "icon"
        case iconGray = "icongray"
    }
}

// MARK: - Stat
struct Stat: Codable {
    let name: String
    let defaultValue: Int?
    let displayName: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case defaultValue = "defaultvalue"
        case displayName = "displayName"
    }
}
