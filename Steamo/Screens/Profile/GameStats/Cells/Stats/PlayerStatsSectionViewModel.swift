//
//  UserStatsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class PlayerStatsSectionViewModel: StatsSectionViewModelRepresentable {
    var type: StatsSectionViewModelType {
        return .playerStats
    }
    
    var rowCount: Int {
        return stats.playerStats?.stats?.count ?? 0
    }
    
    var sectionTitle: String {
        return "Stats"
    }
    
    private var values: [Double: Double] = [487700: 500, 487720: 300]
    
    private var stats: PlayerStats
    private var gameSchema: GameSchema?
    
    init(stats: PlayerStats, gameSchema: GameSchema?) {
        self.stats = stats
        self.gameSchema = gameSchema
        loadValuesFromDatabase()
    }
    
    func statDisplayName(at index: Int) -> String {
        let allStats = gameSchema?.game.availableGameStats?.stats
        let playerStat = allStats?.first(where: { $0.name == stats.playerStats?.stats?[safe: index]?.name })
        
        let isStatNameAvailable = !(playerStat?.displayName?.isEmpty ?? true)
        
        return (isStatNameAvailable ? playerStat?.displayName : playerStat?.name) ?? "No stat name"
    }
    
    func lineChartValues(at index: Int) -> [Double: Double] {
        var newValues: [Double: Double] = [:]
        
        let date = Date()
        let minuteInYear = Calendar.autoupdatingCurrent.ordinality(of: .minute, in: .year, for: date)
        let minuteInYearDbl = Double(minuteInYear ?? 0)
        
        let date1 = Date().addingTimeInterval(500)
        let minuteInYear1 = Calendar.autoupdatingCurrent.ordinality(of: .minute, in: .year, for: date1)
        let minuteInYearDbl1 = Double(minuteInYear1 ?? 0)
        
        let date2 = Date().addingTimeInterval(1000)
        let minuteInYear2 = Calendar.autoupdatingCurrent.ordinality(of: .minute, in: .year, for: date2)
        let minuteInYearDbl2 = Double(minuteInYear2 ?? 0)
        
        newValues[minuteInYearDbl] = stats.playerStats?.stats?[safe: index]?.value
        newValues[minuteInYearDbl1] = 1000
        newValues[minuteInYearDbl2] = 2500
        return values + newValues
    }
    
    private func loadValuesFromDatabase() {
        
    }
}
