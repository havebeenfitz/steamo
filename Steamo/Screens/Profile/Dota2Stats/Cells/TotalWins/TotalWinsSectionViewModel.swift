//
//  TotalWinsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class TotalWinsSectionViewModel: Dota2StatsSectionViewModelRepresentable {
    
    enum MatchResult {
        case won
        case lost
    }
    
    var type: Dota2StatsSectionViewModelType {
        return .totalWins
    }
    
    var sectionTitle: String {
        let wonMatches = Double(result[.won]?.count ?? 0)
        let totalMatches = Double((result[.won]?.count ?? 0) + (result[.lost]?.count ?? 0))
        let winRate = wonMatches / totalMatches
        return "Win Rate \((winRate * 1000).rounded() / 10)%"
    }
    
    var matchDetailsCollection: [MatchDetails]
    
    var steamId: String
    
    var result: [MatchResult: [Int]] = [.won: [], .lost: []]
    
    init(matchDetailsCollection: [MatchDetails],
         steamId: String) {
        self.matchDetailsCollection = matchDetailsCollection
        self.steamId = steamId
    }
    
    
    
    func chartValues() -> [MatchResult: [Int]] {
        
        let steamId32 = String.convertSteamID64(toSteamID32: steamId)
        
        matchDetailsCollection.forEach { matchDetails in
            let currentPlayer = matchDetails.result.players.first(where: { "\($0.accountId)" == steamId32 })
            let isRadiantPlayer = currentPlayer?.playerSlot.bits.first == .zero
            let isRadiantWon = matchDetails.result.radiantWin
            
            let isDirePlayer = currentPlayer?.playerSlot.bits.first == .one
            let isDireWon = !matchDetails.result.radiantWin
            
            if (isRadiantPlayer && isRadiantWon) || (isDirePlayer && isDireWon) {
                result[MatchResult.won]?.append(matchDetails.result.matchId)
            } else {
                result[MatchResult.lost]?.append(matchDetails.result.matchId)
            }
        }
        
        return result
    }
}
