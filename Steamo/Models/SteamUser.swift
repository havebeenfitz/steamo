//
//  SteamUser.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class SteamUser: NSObject, NSCoding {
    var steamID64: String?
    var steamID32: String?
    var steamVanityID: String?

    init(steamID32: String) {
        self.steamID32 = steamID32
    }

    init(steamID64: String) {
        self.steamID64 = steamID64
        steamID32 = String.convertSteamID64(toSteamID32: steamID64)
    }

    init(steamVanityID: String) {
        self.steamVanityID = steamVanityID
        steamID64 = String.convertVanityID(toSteamID64: steamVanityID)
        steamID32 = String.convertSteamID64(toSteamID32: steamID64!)
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(steamID64, forKey: "steamID64")
        encoder.encode(steamID32, forKey: "steamID32")
        encoder.encode(steamVanityID, forKey: "steamVanityID")
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let steamID32 = aDecoder.decodeObject(forKey: "steamID32") as? String ?? ""
        self.init(steamID32: steamID32)
        steamID64 = aDecoder.decodeObject(forKey: "steamID64") as? String
        self.steamID32 = aDecoder.decodeObject(forKey: "steamID32") as? String
        steamVanityID = aDecoder.decodeObject(forKey: "steamVanityID") as? String
    }
}

extension SteamUser {
    static func load() -> SteamUser? {
        let defaults = UserDefaults.standard
        guard let encodedObject = defaults.data(forKey: "SteamUser") else { return nil }
        let object = NSKeyedUnarchiver.unarchiveObject(with: encodedObject) as? SteamUser
        return object
    }

    func save() {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedObject, forKey: "SteamUser")
    }
}
