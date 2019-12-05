//
//  OlderSessionSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 05.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class OlderSessionsSectionViewModel: SessionSectionViewModelRepresentable {
    var index: Int {
        return 1
    }
    
    var type: SesstionSectionViewModelType {
        return .older
    }
    
    var rowCount: Int {
        return games.count
    }
    
    var sectionTitle: String {
        return "Older than 2 weeks"
    }
    
    var games: [Game]
    
    init(games: [Game]) {
        self.games = games
    }
}
