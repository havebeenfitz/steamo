//
//  Profile.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

struct Profile: Codable {
    let response: ProfileResponse
}

struct ProfileResponse: Codable {
    let players: [Player]
}

struct Player: Codable {
    let steamId: String
    let communityVisibilityState: Int
    let personaName: String
    let profileURL: String
    let avatar: String
    let avatarMedium: String
    let avatarFull: String
    let personaState: Int
    let profileState: Int?
    let primaryClanId: String
    let timeCreated: Int
    let personaStateFlags: Int

    enum CodingKeys: String, CodingKey {
        case steamId = "steamid"
        case communityVisibilityState = "communityvisibilitystate"
        case personaName = "personaname"
        case profileURL = "profileurl"
        case avatar = "avatar"
        case avatarMedium = "avatarmedium"
        case avatarFull = "avatarfull"
        case personaState = "personastate"
        case profileState = "profilestate"
        case primaryClanId = "primaryclanid"
        case timeCreated = "timecreated"
        case personaStateFlags = "personastateflags"
    }
}
