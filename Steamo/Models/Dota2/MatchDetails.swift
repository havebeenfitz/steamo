//
//  MatchDetails.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

// MARK: - MatchDetails
struct MatchDetails: Codable {
    let result: MatchResult
}

// MARK: - Result
struct MatchResult: Codable {
    let players: [Dota2DetailPlayer]
    let radiantWin: Bool
    let duration: Int?
    let preGameDuration: Int?
    let startTime: Double?
    let matchId: Int
    let matchSeqNum: Int
    let towerStatusRadiant: Int?
    let towerStatusDire: Int?
    let barracksStatusRadiant: Int?
    let barracksStatusDire: Int?
    let cluster: Int?
    let firstBloodTime: Int?
    let lobbyType: Int?
    let humanPlayers: Int?
    let leagueid: Int?
    let positiveVotes: Int?
    let negativeVotes: Int?
    let gameMode: Int?
    let flags: Int?
    let engine: Int?
    let radiantScore: Int?
    let direScore: Int?
    let picksBans: [PicksBan]?

    enum CodingKeys: String, CodingKey {
        case players = "players"
        case radiantWin = "radiant_win"
        case duration = "duration"
        case preGameDuration = "pre_game_duration"
        case startTime = "start_time"
        case matchId = "match_id"
        case matchSeqNum = "match_seq_num"
        case towerStatusRadiant = "tower_status_radiant"
        case towerStatusDire = "tower_status_dire"
        case barracksStatusRadiant = "barracks_status_radiant"
        case barracksStatusDire = "barracks_status_dire"
        case cluster = "cluster"
        case firstBloodTime = "first_blood_time"
        case lobbyType = "lobby_type"
        case humanPlayers = "human_players"
        case leagueid = "leagueid"
        case positiveVotes = "positive_votes"
        case negativeVotes = "negative_votes"
        case gameMode = "game_mode"
        case flags = "flags"
        case engine = "engine"
        case radiantScore = "radiant_score"
        case direScore = "dire_score"
        case picksBans = "picks_bans"
    }
}

// MARK: - PicksBan
struct PicksBan: Codable {
    let isPick: Bool?
    let heroId: Int?
    let team: Int?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case isPick = "is_pick"
        case heroId = "hero_id"
        case team = "team"
        case order = "order"
    }
}

// MARK: - Player
struct Dota2DetailPlayer: Codable {
    let accountId: Int
    let playerSlot: UInt8
    let heroId: Int
    let item0: Int?
    let item1: Int?
    let item2: Int?
    let item3: Int?
    let item4: Int?
    let item5: Int?
    let backpack0: Int?
    let backpack1: Int?
    let backpack2: Int?
    let kills: Int?
    let deaths: Int?
    let assists: Int?
    let leaverStatus: Int?
    let lastHits: Int?
    let denies: Int?
    let goldPerMin: Int?
    let xpPerMin: Int?
    let level: Int?
    let heroDamage: Int?
    let towerDamage: Int?
    let heroHealing: Int?
    let gold: Int?
    let goldSpent: Int?
    let scaledHeroDamage: Int?
    let scaledTowerDamage: Int?
    let scaledHeroHealing: Int?
    let abilityUpgrades: [AbilityUpgrade]?

    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case playerSlot = "player_slot"
        case heroId = "hero_id"
        case item0 = "item_0"
        case item1 = "item_1"
        case item2 = "item_2"
        case item3 = "item_3"
        case item4 = "item_4"
        case item5 = "item_5"
        case backpack0 = "backpack_0"
        case backpack1 = "backpack_1"
        case backpack2 = "backpack_2"
        case kills = "kills"
        case deaths = "deaths"
        case assists = "assists"
        case leaverStatus = "leaver_status"
        case lastHits = "last_hits"
        case denies = "denies"
        case goldPerMin = "gold_per_min"
        case xpPerMin = "xp_per_min"
        case level = "level"
        case heroDamage = "hero_damage"
        case towerDamage = "tower_damage"
        case heroHealing = "hero_healing"
        case gold = "gold"
        case goldSpent = "gold_spent"
        case scaledHeroDamage = "scaled_hero_damage"
        case scaledTowerDamage = "scaled_tower_damage"
        case scaledHeroHealing = "scaled_hero_healing"
        case abilityUpgrades = "ability_upgrades"
    }
}

// MARK: - AbilityUpgrade
struct AbilityUpgrade: Codable {
    let ability: Int?
    let time: Int?
    let level: Int?
}
