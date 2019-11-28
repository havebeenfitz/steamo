//
//  SteamVanity.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

struct SteamVanity: Codable {
    let response: SteamVanityResponse?

    enum CodingKeys: String, CodingKey {
        case response
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decodeIfPresent(SteamVanityResponse.self, forKey: .response)
    }
}

struct SteamVanityResponse: Codable {
    let steamid: String?
    let success: Int?

    enum CodingKeys: String, CodingKey {
        case steamid
        case success
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        steamid = try values.decodeIfPresent(String.self, forKey: .steamid)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
    }
}
