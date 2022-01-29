//
//  MatchDetails.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// MARK: - MatchDetails
class MatchDetails: Codable {
    let result: Dota2MatchResult
}

// MARK: - Result
class Dota2MatchResult: Object, Codable {
    @objc dynamic var ownerSteamId: String? = nil
    dynamic var players: List<Dota2DetailPlayer> = List()
    @objc dynamic var radiantWin: Bool = false
    dynamic var startTime: RealmProperty<Double?> = RealmProperty()
    @objc dynamic var matchId: Int = 0

    enum CodingKeys: String, CodingKey {
        case players = "players"
        case radiantWin = "radiant_win"
        case startTime = "start_time"
        case matchId = "match_id"
    }
    
    override class func primaryKey() -> String? {
         return "matchId"
    }
        
    required override init() {
        super.init()
    }
        
    convenience init(ownerSteamId: String, matchResult: Dota2MatchResult) {
        self.init()
        self.ownerSteamId = ownerSteamId
        self.players = matchResult.players
        self.radiantWin = matchResult.radiantWin
        self.startTime = matchResult.startTime
        self.matchId = matchResult.matchId
    }
    
    convenience init(players: [Dota2DetailPlayer], radiantWin: Bool, startTime: Double?, matchId: Int) {
        self.init()
        let list: List<Dota2DetailPlayer> = List()
        list.append(objectsIn: players)
        self.players = list
        self.radiantWin = radiantWin
        self.startTime.value = startTime
        self.matchId = matchId
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let players = try container.decode([Dota2DetailPlayer].self, forKey: .players)
        let radiantWin = try container.decode(Bool.self, forKey: .radiantWin)
        let startTime = try container.decodeIfPresent(Double.self, forKey: .startTime)
        let matchId = try container.decode(Int.self, forKey: .matchId)
        self.init(players: players, radiantWin: radiantWin, startTime: startTime, matchId: matchId)
    }
}

// MARK: - Player
class Dota2DetailPlayer: Object, Codable {
    @objc dynamic var uuid: String? = UUID().uuidString
    dynamic var accountId: RealmProperty<Int?> = RealmProperty()
    @objc dynamic var playerSlot: Int = 0

    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case playerSlot = "player_slot"
    }
    
    override class func primaryKey() -> String? {
         return "uuid"
    }
        
    convenience init(existing: Dota2DetailPlayer) {
        self.init()
        self.uuid = existing.uuid
        self.accountId = existing.accountId
        self.playerSlot = existing.playerSlot
    }
    
    convenience init(accountId: Int?, playerSlot: Int) {
        self.init()
        let accountIdRealm = RealmProperty<Int?>()
        accountIdRealm.value = accountId
        self.accountId = accountIdRealm
        self.playerSlot = playerSlot
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let accountId = try container.decodeIfPresent(Int.self, forKey: .accountId)
        let playerSlot = try container.decode(Int.self, forKey: .playerSlot)
        self.init(accountId: accountId, playerSlot: playerSlot)
    }
}
