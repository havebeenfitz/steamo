//
//  AuthRequestBuilder.swift
//  Steamo
//
//  Created by Max Kraev on 24.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class AuthRequestBuilder {
    /// Запрос на авторизацию
    static func authRequest() -> URLRequest {
        return URLRequest(url: API.authURL)
    }
}
