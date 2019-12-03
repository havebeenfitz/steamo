//
//  NoFriendsSectionViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class NoFriendsSectionViewModel: ProfileSectionViewModelRepresentable {
    var index: Int {
        return 2
    }
    
    var type: ProfileSectionViewModelType {
        .noVisibleFriends
    }
    
    var sectionTitle: String {
        return "Friends"
    }
}
