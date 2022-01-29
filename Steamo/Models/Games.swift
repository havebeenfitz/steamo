//
//  Games.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Games: Codable {
    let response: GamesResponse?
}

class GamesResponse: Codable {
    let gameCount: Int?
    let totalCount: Int?
    let games: [Game]?

    enum CodingKeys: String, CodingKey {
        case gameCount = "game_count"
        case totalCount = "total_count"
        case games
    }
}

class Game: Object, Codable {
    @objc dynamic var uuid: String? = UUID().uuidString
    @objc dynamic var ownerSteamId: String? = ""
    @objc dynamic var appId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var playtimeForever: Int = 0
    var playtime2Weeks: RealmOptional<Int> = RealmOptional()
    @objc dynamic var imgIconUrl: String = ""
    @objc dynamic var imgLogoUrl: String = ""

    enum CodingKeys: String, CodingKey {
        case appId = "appid"
        case name
        case playtimeForever = "playtime_forever"
        case imgIconUrl = "img_icon_url"
        case imgLogoUrl = "img_logo_url"
        case playtime2Weeks = "playtime_2weeks"
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    convenience init(playtime2Weeks: Int?, game: Game) {
        self.init()
        self.uuid = game.uuid
        self.ownerSteamId = game.ownerSteamId
        self.appId = game.appId
        self.name = game.name
        self.playtimeForever = game.playtimeForever
        self.imgIconUrl = game.imgIconUrl
        self.imgLogoUrl = game.imgLogoUrl
        self.playtime2Weeks.value = playtime2Weeks
    }
    
    convenience init(ownerSteamId: String, playtimeForever: Int, playtime2Weeks: Int?, game: Game) {
        self.init()
        self.uuid = game.uuid
        self.ownerSteamId = ownerSteamId
        self.appId = game.appId
        self.name = game.name
        self.playtimeForever = playtimeForever
        self.playtime2Weeks.value = playtime2Weeks
        self.imgIconUrl = game.imgIconUrl
        self.imgLogoUrl = game.imgLogoUrl
    }
    
    convenience init(appId: Int, name: String, playtimeForever: Int, playtime2Weeks: Int?, imgIconUrl: String, imgLogoUrl: String) {
        self.init()
        self.appId = appId
        self.name = name
        self.playtimeForever = playtimeForever
        self.imgIconUrl = imgIconUrl
        self.imgLogoUrl = imgLogoUrl
        self.playtime2Weeks.value = playtime2Weeks
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let appId = try container.decode(Int.self, forKey: .appId)
        let name = try container.decode(String.self, forKey: .name)
        let playtimeForever = try container.decode(Int.self, forKey: .playtimeForever)
        let playtime2Weeks = try container.decodeIfPresent(Int.self, forKey: .playtime2Weeks)
        let imgIconUrl = try container.decode(String.self, forKey: .imgIconUrl)
        let imgLogoUrl = try container.decode(String.self, forKey: .imgLogoUrl)
        
        self.init(appId: appId, name: name, playtimeForever: playtimeForever, playtime2Weeks: playtime2Weeks, imgIconUrl: imgIconUrl, imgLogoUrl: imgLogoUrl)
    }
}

extension Game {
    var calculatedImageLogoUrl: URL? {
        return URL(string: "http://media.steampowered.com/steamcommunity/public/images/apps/\(appId)/\(imgLogoUrl).jpg")
    }

    var calculatedImageIconUrl: URL? {
        return URL(string: "http://media.steampowered.com/steamcommunity/public/images/apps/\(appId)/\(imgLogoUrl).jpg")
    }
}
