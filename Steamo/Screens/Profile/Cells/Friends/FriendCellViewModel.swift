//
//  FriendsCellViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class FriendsSectionViewModel: ProfileSectionViewModelRepresentable {
    var index: Int {
        return 2
    }

    var type: ProfileCellViewModelType {
        return .friends
    }

    var sectionTitle: String {
        return "Friends (\(profiles.response.players.count))"
    }

    var rowCount: Int {
        return profiles.response.players.count
    }

    var profiles: Profiles

    init(profiles: Profiles) {
        self.profiles = profiles
    }
}
