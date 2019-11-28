//
//  Games.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

struct Games: Codable {
    let response: GamesResponse
}

struct GamesResponse: Codable {
    let gameCount: Int?
    let totalCount: Int?
    let games: [Game]

    enum CodingKeys: String, CodingKey {
        case gameCount = "game_count"
        case totalCount = "total_count"
        case games
    }
}

struct Game: Codable {
    let appId: Int
    let name: String
    let playtimeForever: Int
    let imgIconUrl: String
    let imgLogoUrl: String
    let hasCommunityVisibleStats: Bool?
    let playtimeWindowsForever: Int
    let playtimeMacForever: Int
    let playtimeLinuxForever: Int
    let playtime2Weeks: Int?

    enum CodingKeys: String, CodingKey {
        case appId = "appid"
        case name
        case playtimeForever = "playtime_forever"
        case imgIconUrl = "img_icon_url"
        case imgLogoUrl = "img_logo_url"
        case hasCommunityVisibleStats = "has_community_visible_stats"
        case playtimeWindowsForever = "playtime_windows_forever"
        case playtimeMacForever = "playtime_mac_forever"
        case playtimeLinuxForever = "playtime_linux_forever"
        case playtime2Weeks = "playtime_2weeks"
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
