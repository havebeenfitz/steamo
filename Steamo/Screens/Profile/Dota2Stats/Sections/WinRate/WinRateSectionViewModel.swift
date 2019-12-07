//
//  TotalWinsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class WinRateSectionViewModel: Dota2StatsSectionViewModelRepresentable {
    
    enum MatchResult {
        case won
        case lost
    }
    
    var type: Dota2StatsSectionViewModelType {
        return .winRate
    }
    
    var sectionTitle: String {
        let wonMatches = Double(result[.won]?.count ?? 0)
        let totalMatches = Double((result[.won]?.count ?? 0) + (result[.lost]?.count ?? 0))
        let winRate = wonMatches / totalMatches
        return "Win Rate \((winRate * 1000).rounded() / 10)%, \(Int(totalMatches)) matches total"
    }
    
    private let databaseManager: DatabaseManagerProtocol

    var steamId: String
    
    var result: [MatchResult: [Int]] = [.won: [], .lost: []]
    
    init(databaseManager: DatabaseManagerProtocol,
         steamId: String) {
        self.databaseManager = databaseManager
        self.steamId = steamId
    }
    
    
    
    func chartValues() -> [MatchResult: [Int]] {
        
        result = [.won: [], .lost: []]
        
        let steamId32 = String.convertSteamID64(toSteamID32: steamId)
        
        let matches: [Dota2MatchResult] = databaseManager.load(filter: { $0.ownerSteamId == self.steamId })
        
        matches.forEach { match in
            let currentPlayer = match.players.first(where: { "\($0.accountId)" == steamId32 })
            
            let isRadiantPlayer = currentPlayer?.playerSlot.bits.first == .zero
            let isRadiantWon = match.radiantWin
            
            let isDirePlayer = currentPlayer?.playerSlot.bits.first == .one
            let isDireWon = !match.radiantWin
            
            if (isRadiantPlayer && isRadiantWon) || (isDirePlayer && isDireWon) {
                result[MatchResult.won]?.append(match.matchId)
            } else {
                result[MatchResult.lost]?.append(match.matchId)
            }
        }
        
        return result
    }
}
