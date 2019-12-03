//
//  NoGamesSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 04.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class NoOwnedGamesSectionViewModel: ProfileSectionViewModelRepresentable {
    var index: Int {
        return 1
    }
    
    var type: ProfileSectionViewModelType {
        return .noVisibleGames
    }
    
    var sectionTitle: String {
        return "Games"
    }
}
