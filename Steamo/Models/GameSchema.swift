//
//  GameSchema.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// MARK: - GameSchema
class GameSchema: Codable {
    let game: GameStats
}

// MARK: - Game
class GameStats: Codable {
    let gameName: String?
    let gameVersion: String?
    let availableGameStats: AvailableGameStats?
}

// MARK: - AvailableGameStats
class AvailableGameStats: Codable {
    let stats: [StatSchema]?
    let achievements: [Achievement]?
}

// MARK: - Achievement
class Achievement: Codable, Hashable {
    
    let name: String
    let defaultValue: Int
    let displayName: String?
    let hidden: Int
    let description: String?
    let icon: String
    let iconGray: String

    enum CodingKeys: String, CodingKey {
        case name
        case defaultValue = "defaultvalue"
        case displayName
        case hidden
        case description
        case icon
        case iconGray = "icongray"
    }
    
    static func == (lhs: Achievement, rhs: Achievement) -> Bool {
        return lhs.icon == rhs.icon && lhs.iconGray == rhs.iconGray
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine((icon + iconGray).hashValue)
    }
}

// MARK: - Stat
class StatSchema: Object, Codable {
    @objc dynamic var uuid: String? = UUID().uuidString
    var gameId: RealmOptional<Int> = RealmOptional()
    @objc dynamic var name: String = ""
    var defaultValue: RealmOptional<Double> = RealmOptional()
    @objc dynamic var displayName: String? = ""

    enum CodingKeys: String, CodingKey {
        case name
        case defaultValue = "defaultvalue"
        case displayName
    }
    
    override class func primaryKey() -> String? {
           return "uuid"
       }
       
       required init() {
           super.init()
       }
       
    convenience init(gameId: Int, stat: StatSchema) {
        self.init()
        self.gameId.value = gameId
        self.uuid = stat.uuid
        self.name = stat.name
        self.displayName = stat.displayName
        self.defaultValue = stat.defaultValue
    }
   
    convenience init(name: String, defaultValue: Double?, displayName: String?) {
        self.init()
        self.uuid = UUID().uuidString
        self.name = name
        self.defaultValue.value = defaultValue
        self.displayName = displayName
    }
   
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let defaultValue = try container.decodeIfPresent(Double.self, forKey: .defaultValue)
        let displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.init(name: name, defaultValue: defaultValue, displayName: displayName)
   }
}
