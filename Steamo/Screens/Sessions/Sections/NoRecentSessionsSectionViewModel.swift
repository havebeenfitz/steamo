//
//  NoRecentSessionsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 07.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class NoRecentSessionsSectionViewModel: SessionSectionViewModelRepresentable {
    var index: Int {
        return 0
    }
    
    var type: SesstionSectionViewModelType {
        return .nothingInTwoWeeks
    }
    
    var rowCount: Int {
        return 1
    }
    
    var sectionTitle: String {
        return "Last two weeks"
    }
    
    var games: [Game] = []
}

