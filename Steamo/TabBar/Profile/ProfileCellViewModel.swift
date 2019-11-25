//
//  ProfileCellViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

enum ProfileCellViewModelType {
    case avatar
    case ownedGames
}

protocol ProfileCellViewModel {
    var type: ProfileCellViewModelType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}

extension ProfileCellViewModel {
    var rowCount: Int {
        return 1
    }
}
