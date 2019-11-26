//
//  GamesBoughtViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

class OwnedGamesCellViewModel: ProfileCellViewModelRepresentable {
    var index: Int {
        return 1
    }
    
    var type: ProfileCellViewModelType {
        return .ownedGames
    }
    
    var sectionTitle: String {
        return "Games (\(games.response.gameCount ?? 0))"
    }
    
    var games: Games
    
    init(games: Games) {
        self.games = games
    }
}
