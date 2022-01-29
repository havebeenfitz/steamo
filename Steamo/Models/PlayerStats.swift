//
//  PlayerStats.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// MARK: - PlayerStats
class PlayerStats: Codable {
    let playerStats: Stats?

    enum CodingKeys: String, CodingKey {
        case playerStats = "playerstats"
    }
}

// MARK: - Playerstats
class Stats: Codable {
    let steamId: String?
    let gameName: String?
    let stats: [PlayerStat]?
    let achievements: [PlayerAchievement]?

    enum CodingKeys: String, CodingKey {
        case steamId = "steamID"
        case gameName
        case stats
        case achievements
    }
}

// MARK: - Achievement
class PlayerAchievement: Object, Codable {
    @objc dynamic var uuid: String? = UUID().uuidString
    @objc dynamic var ownerSteamId: String? = ""
    var gameId: RealmOptional<Int> = RealmOptional()
    @objc dynamic var name: String = ""
    @objc dynamic var achieved: Int = 0

    enum CodingKeys: String, CodingKey {
        case name
        case achieved
    }
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    convenience init(gameId: Int, ownerSteamId: String, achievement: PlayerAchievement) {
        self.init()
        self.gameId.value = gameId
        self.ownerSteamId = ownerSteamId
        self.uuid = achievement.uuid
        self.name = achievement.name
        self.achieved = achievement.achieved
    }
    
    convenience init(name: String, achieved: Int) {
        self.init()
        self.uuid = UUID().uuidString
        self.name = name
        self.achieved = achieved
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let achieved = try container.decode(Int.self, forKey: .achieved)
        self.init(name: name, achieved: achieved)
    }
    
}

// MARK: - Stat
class PlayerStat: Object, Codable {
    @objc dynamic var uuid: String? = UUID().uuidString
    @objc dynamic var ownerSteamId: String? = ""
    var gameId: RealmOptional<Int> = RealmOptional()
    var createdAt: RealmOptional<TimeInterval> = RealmOptional()
    @objc dynamic var name: String = ""
    @objc dynamic var value: Double = 0
    @objc dynamic var displayName: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
    }
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    convenience init(gameId: Int, createdAt: TimeInterval, ownerSteamId: String, displayName: String, stat: PlayerStat) {
        self.init()
        self.gameId.value = gameId
        self.createdAt.value = createdAt
        self.ownerSteamId = ownerSteamId
        self.uuid = stat.uuid
        self.name = stat.name
        self.value = stat.value
        self.displayName = displayName
    }
    
    convenience init(name: String, value: Double) {
        self.init()
        self.uuid = UUID().uuidString
        self.name = name
        self.value = value
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let value = try container.decode(Double.self, forKey: .value)
        self.init(name: name, value: value)
    }
}


