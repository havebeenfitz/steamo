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
    private var data: [DateComponents: MatchResult] = [:]
    
    init(matchDetailsCollection: [MatchDetails],
         steamId: String) {
        self.matchDetailsCollection = matchDetailsCollection
        self.steamId = steamId
        processData()
    }
    
    func matchesByDay(_ result: MatchResult) -> [Double: Double] {
        var chartData: [Double: Double] = [:]
        
        data.filter { $0.value == result }
            .keys
            .forEach { dateComponent in
                let dayInYear = dateComponent.calendar?.ordinality(of: .day, in: .year, for: dateComponent.date ?? Date())
                let dayScale = Double(dayInYear ?? 0)
                if chartData[dayScale] != nil {
                    switch result {
                    case .won:
                        chartData[dayScale]! += 1
                    case .lost:
                        chartData[dayScale]! -= 1
                    }
                } else {
                    switch result {
                    case .won:
                        chartData[dayScale] = 1
                    case .lost:
                        chartData[dayScale] = -1
                    }
                }
        }
        
        return chartData
    }
    
    func matchesByHour(_ result: MatchResult) -> [Double: Double] {
        var chartData: [Double: Double] = [:]
        
        data.filter { $0.value == result }
            .keys
            .forEach { dateComponent in
                let hourInYear = dateComponent.calendar?.ordinality(of: .hour, in: .year, for: dateComponent.date ?? Date())
                let dayScale = Double(hourInYear ?? 0)
                if chartData[dayScale] != nil {
                    switch result {
                    case .won:
                        chartData[dayScale]! += 1
                    case .lost:
                        chartData[dayScale]! -= 1
                    }
                } else {
                    switch result {
                    case .won:
                        chartData[dayScale] = 1
                    case .lost:
                        chartData[dayScale] = -1
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
            var dateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: date)
            dateComponents.calendar = Calendar.current
            
            if (isRadiantPlayer && isRadiantWon) || (isDirePlayer && isDireWon) {
                data[dateComponents] = .won
            } else {
                data[dateComponents] = .lost
            }
        }
    }
}
