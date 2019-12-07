//
//  TwoWeekSessionSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 05.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class TwoWeekSessionsSectionViewModel: SessionSectionViewModelRepresentable {
    var index: Int {
        return 0
    }
    
    var type: SesstionSectionViewModelType {
        return .inTwoWeeks
    }
    
    var rowCount: Int {
        return games.count
    }
    
    var sectionTitle: String {
        return "Last 2 weeks"
    }
    
    var games: [Game]
    
    init(games: [Game]) {
        self.games = games
    }
    
}
