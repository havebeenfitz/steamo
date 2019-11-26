//
//  FriendsCellViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class FriendsCellViewModel: ProfileCellViewModelRepresentable {
    var index: Int {
        return 2
    }
    
    var type: ProfileCellViewModelType {
        return .friends
    }
    
    var sectionTitle: String {
        return "Friends ()"
    }
    
    var friends: Friends
    
    init(friends: Friends) {
        self.friends = friends
    }
}
