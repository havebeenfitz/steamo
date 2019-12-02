//
//  ProfileCellViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

enum ProfileSectionViewModelType {
    case avatar
    case ownedGames
    case friends
}

protocol ProfileSectionViewModelRepresentable {
    var index: Int { get }
    var type: ProfileSectionViewModelType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}

extension ProfileSectionViewModelRepresentable {
    var rowCount: Int {
        return 1
    }
}
