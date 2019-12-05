//
//  Dota2ErrorSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 04.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class Dota2ErrorSectionViewModel: Dota2StatsSectionViewModelRepresentable {
    var type: Dota2StatsSectionViewModelType {
        return .error
    }
    
    var sectionTitle: String {
        return ""
    }
}
