//
//  MatchHistory.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

// MARK: - MatchHistory
struct MatchHistory: Codable {
    let result: MatchHistoryResult
}

// MARK: - Result
struct MatchHistoryResult: Codable {
    let status: Int
    let numResults: Int?
    let totalResults: Int?
    let resultsRemaining: Int?
    let matches: [Match]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case numResults = "num_results"
        case totalResults = "total_results"
        case resultsRemaining = "results_remaining"
        case matches = "matches"
    }
}

// MARK: - Match
struct Match: Codable, Hashable {
    let matchId: Int
    let matchSeqNum: Int
    let startTime: Double
    let lobbyType: Int
    let radiantTeamId: Int
    let direTeamId: Int
    let players: [Dota2Player]

    enum CodingKeys: String, CodingKey {
        case matchId = "match_id"
        case matchSeqNum = "match_seq_num"
        case startTime = "start_time"
        case lobbyType = "lobby_type"
        case radiantTeamId = "radiant_team_id"
        case direTeamId = "dire_team_id"
        case players = "players"
    }
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.matchId == rhs.matchId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.matchId)
    }
}

// MARK: - Player
struct Dota2Player: Codable {
    let accountId: Int?
    let playerSlot: Int
    let heroId: Int

    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case playerSlot = "player_slot"
        case heroId = "hero_id"
    }
}
