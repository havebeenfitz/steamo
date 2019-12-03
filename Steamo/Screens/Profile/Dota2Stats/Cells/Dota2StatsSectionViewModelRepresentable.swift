//
//  Dota2StatsSectionViewModelRepresentable.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

enum Dota2StatsSectionViewModelType {
    case gameSummary
    case totalWins
    case winsByDate
}

protocol Dota2StatsSectionViewModelRepresentable {
    var type: Dota2StatsSectionViewModelType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}

extension Dota2StatsSectionViewModelRepresentable {
    var rowCount: Int {
        return 1
    }
}
