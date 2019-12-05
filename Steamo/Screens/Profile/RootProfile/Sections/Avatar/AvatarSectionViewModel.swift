//
//  ProfileCellViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

class AvatarSectionViewModel: ProfileSectionViewModelRepresentable {
    var index: Int {
        return 0
    }

    var type: ProfileSectionViewModelType {
        return .avatar
    }

    var sectionTitle: String {
        return "User"
    }

    var profiles: Profiles

    init(profiles: Profiles) {
        self.profiles = profiles
    }
}
