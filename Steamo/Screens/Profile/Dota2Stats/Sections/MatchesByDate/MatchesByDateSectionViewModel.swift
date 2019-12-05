//
//  MatchesByDateSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 04.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class MatchesByDateSectionViewModel: Dota2StatsSectionViewModelRepresentable {
    
    enum MatchResult {
        case won
        case lost
    }
    
    var type: Dota2StatsSectionViewModelType {
        .matchesByDate
    }
    
    var sectionTitle: String {
        return "Matches by Date"
    }
    
    private var matchDetailsCollection: [MatchDetails]
    private var steamId: String
    private var data: [Date: MatchResult] = [:]
    
    init(matchDetailsCollection: [MatchDetails],
         steamId: String) {
        self.matchDetailsCollection = matchDetailsCollection
        self.steamId = steamId
        processData()
    }
    
    func matchesBy(_ component: Calendar.Component, result: MatchResult) -> [Double: Double] {
        var chartData: [Double: Double] = [:]
        
        data.filter { $0.value == result }
            .keys
            .forEach { date in
                let componentValueInYear = Calendar.autoupdatingCurrent.ordinality(of: component, in: .year, for: date)
                let componentXAxis = Double(componentValueInYear ?? 0)
                if chartData[componentXAxis] != nil {
                    switch result {
                    case .won:
                        chartData[componentXAxis]! += 1
                    case .lost:
                        chartData[componentXAxis]! -= 1
                    }
                } else {
                    switch result {
                    case .won:
                        chartData[componentXAxis] = 1
                    case .lost:
                        chartData[componentXAxis] = -1
                    }
                }
        }
        
        return chartData
    }
    
    private func processData() {
        let steamId32 = String.convertSteamID64(toSteamID32: steamId)
        
        matchDetailsCollection.forEach { matchDetails in
            let currentPlayer = matchDetails.result.players.first(where: { "\($0.accountId)" == steamId32 })
            let isRadiantPlayer = currentPlayer?.playerSlot.bits.first == .zero
            let isRadiantWon = matchDetails.result.radiantWin
            
            let isDirePlayer = currentPlayer?.playerSlot.bits.first == .one
            let isDireWon = !matchDetails.result.radiantWin
            
            let date = Date(timeIntervalSince1970: matchDetails.result.startTime ?? 0)
            
            if (isRadiantPlayer && isRadiantWon) || (isDirePlayer && isDireWon) {
                data[date] = .won
            } else {
                data[date] = .lost
            }
        }
    }
}
