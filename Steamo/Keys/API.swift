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
    static let authURL: URL = URL(string: "https://steamcommunity.com/mobilelogin")!
    /// Эндпоинт для всех методов API
    static let baseURL: URL = URL(string: "https://api.steampowered.com/")!
    /// API ключ для стима
    static let apiKey: String = "791CF56D766357A65BE321D5C8281F82"
}
