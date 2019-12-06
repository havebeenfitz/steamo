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
        return stats.count
    }
    
    var sectionTitle: String {
        return "Stats"
    }
    
    /// [name: [x: y]]
    private var values: [String: [Double: Double]] = [:]
    private var stats: [PlayerStat] = []
    private let ownerSteamId: String
    private let gameId: Int
    private let databaseManager: DatabaseManagerProtocol
    
    init(ownerSteamId: String, gameId: Int, databaseManager: DatabaseManagerProtocol) {
        self.ownerSteamId = ownerSteamId
        self.gameId = gameId
        self.databaseManager = databaseManager
        loadValuesFromDatabase()
    }
    
    func statDisplayName(at index: Int) -> String {
        if let statName = stats[index].displayName, !statName.isEmpty {
            return statName
        }
        return stats[index].name
    }
    
    func lineChartValues(at index: Int) -> [Double: Double] {
        let name = stats[index].name
        return values[name] ?? [:]
    }
    
    private func loadValuesFromDatabase() {
        let stats: [PlayerStat] = databaseManager.load(filter: { $0.gameId.value == self.gameId && $0.ownerSteamId == self.ownerSteamId })
        values = stats.reduce(into: [String: [Double: Double]]()) { dict, stat in
            let date = Date(timeIntervalSince1970: stat.createdAt.value ?? 0)
            let minuteInYear = Calendar.autoupdatingCurrent.ordinality(of: .minute, in: .year, for: date)
            if dict[stat.name] != nil {
                dict[stat.name]! + [Double(minuteInYear ?? 0): stat.value]
            } else {
                dict[stat.name] = [Double(minuteInYear ?? 0): stat.value]
            }
        }
        
        // Избавляемся от дубликатов
        self.stats = stats.reduce(into: [] , { result, stat in
            let containsStat = result.contains(where: { $0.name == stat.name })
            if !containsStat {
                result.append(stat)
            }
        })
    }
}
