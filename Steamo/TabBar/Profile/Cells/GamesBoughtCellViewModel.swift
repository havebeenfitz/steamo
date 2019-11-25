//
//  GamesBoughtViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

class GamesBoughtCellViewModel: ProfileCellViewModel {
    var type: ProfileCellViewModelType {
        return .gamesBought
    }
    
    var sectionTitle: String {
        return "Games"
    }
}
