//
//  SessionSectionViewModelRepresentable.swift
//  Steamo
//
//  Created by Max Kraev on 05.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

enum SesstionSectionViewModelType {
    case inTwoWeeks
    case older
    case nothing
}

protocol SessionSectionViewModelRepresentable {
    var index: Int { get }
    var type: SesstionSectionViewModelType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
    var games: [Game] { get }
}
