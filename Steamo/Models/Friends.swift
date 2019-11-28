//
//  Friends.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

struct Friends: Codable {
    let friendsList: FriendsList

    enum CodingKeys: String, CodingKey {
        case friendsList = "friendslist"
    }
}

struct FriendsList: Codable {
    let friends: [Friend]

    enum CodingKeys: String, CodingKey {
        case friends
    }
}

// MARK: - Friend

struct Friend: Codable {
    let steamId: String
    let relationship: String
    let friendSince: Int

    enum CodingKeys: String, CodingKey {
        case steamId = "steamid"
        case relationship
        case friendSince = "friend_since"
    }
}
