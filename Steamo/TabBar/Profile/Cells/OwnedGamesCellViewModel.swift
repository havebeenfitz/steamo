//
//  GamesBoughtViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

class OwnedGamesCellViewModel: ProfileCellViewModel {
    var type: ProfileCellViewModelType {
        return .ownedGames
    }
    
    var sectionTitle: String {
        return "Games"
    }
    
    var games: [Game] = []
    
    init(games: [Game]) {
        self.games = games
    }
}
