//
//  NoPlayerStatsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation


class NoPlayerStatsSectionViewModel: StatsSectionViewModelRepresentable {
    var type: StatsSectionViewModelType {
        return .noPlayerStats
    }
    
    var rowCount: Int {
        return 1
    }
    
    var sectionTitle: String {
        return "Stats"
    }
}
