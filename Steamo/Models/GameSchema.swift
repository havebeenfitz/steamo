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
    let achievements: [AchievementSchema]?
}

// MARK: - Achievement
class AchievementSchema: Object, Codable {
    
    @objc dynamic var uuid: String? = UUID().uuidString
    var gameId: RealmOptional<Int> = RealmOptional()
    
    @objc dynamic var name: String = ""
    @objc dynamic var defaultValue: Int = 0
    @objc dynamic var displayName: String? = nil
    @objc dynamic var hidden: Int = 0
    @objc dynamic var descriptionValue: String? = nil
    @objc dynamic var icon: String = ""
    @objc dynamic var iconGray: String = ""

    enum CodingKeys: String, CodingKey {
        case name
        case defaultValue = "defaultvalue"
        case displayName
        case hidden
        case descriptionValue = "description"
        case icon
        case iconGray = "icongray"
    }
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
    
    convenience init(gameId: Int, achievementSchema: AchievementSchema) {
        self.init()
        self.gameId.value = gameId
        self.name = achievementSchema.name
        self.defaultValue = achievementSchema.defaultValue
        self.displayName = achievementSchema.displayName
        self.hidden = achievementSchema.hidden
        self.descriptionValue = achievementSchema.descriptionValue
        self.icon = achievementSchema.icon
        self.iconGray = achievementSchema.iconGray
    }
    
    convenience init(name: String, defaultValue: Int, displayName: String?, hidden: Int, descriptionValue: String?, icon: String, iconGray: String) {
        self.init()
        self.name = name
        self.defaultValue = defaultValue
        self.displayName = displayName
        self.hidden = hidden
        self.descriptionValue = descriptionValue
        self.icon = icon
        self.iconGray = iconGray
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let defaultValue = try container.decode(Int.self, forKey: .defaultValue)
        let displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        let hidden = try container.decode(Int.self, forKey: .hidden)
        let descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
        let icon = try container.decode(String.self, forKey: .icon)
        let iconGray = try container.decode(String.self, forKey: .iconGray)
        
        self.init(name: name, defaultValue: defaultValue, displayName: displayName, hidden: hidden, descriptionValue: descriptionValue, icon: icon, iconGray: iconGray)
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
