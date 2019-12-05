//
//  StatsSectionViewModelRepresentable.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

enum StatsSectionViewModelType {
    case playerStats
    case playerAchievements
    
    case noPlayerStats
    case noPlayerAchievements
    case nothing
}

protocol StatsSectionViewModelRepresentable {
    var type: StatsSectionViewModelType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}
