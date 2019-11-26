//
//  ProfileCellViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

enum UserStatus: Int {
       case offline = 0
       case online = 1
       case busy = 2
       case away = 3
       case snooze = 4
       case trade = 5
       case lookingToPlay = 6
   }

class AvatarCellViewModel: ProfileCellViewModelRepresentable {
    var index: Int {
        return 0
    }
    
    var type: ProfileCellViewModelType {
        return .avatar
    }
    
    var sectionTitle: String {
        return "User"
    }
    
    var avatarURLString: String
    var name: String
    var status: UserStatus
    
    init(avatarURLString: String, name: String, status: UserStatus) {
        self.avatarURLString = avatarURLString
        self.name = name
        self.status = status
    }
}
