//
//  NoSessionsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 05.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class NoSessionsSectionViewModel: SessionSectionViewModelRepresentable {
    var index: Int {
        return 0
    }
    
    var type: SesstionSectionViewModelType {
        return .nothing
    }
    
    var rowCount: Int {
        return 1
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var games: [Game] = []    
}
