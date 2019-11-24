//
//  APIEnpoints.swift
//  Steamo
//
//  Created by Max Kraev on 24.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

/// Эндпоинты
struct API {
    /// Эндпоинт авторизации
    static let authURL: URL = URL(string: "https://steamcommunity.com/openid/login/")!
    /// Куда редиректим после успешной авторизации
    static let redirectURL: URL = URL(string: "https://flip-learn.flycricket.io")!
    
}
