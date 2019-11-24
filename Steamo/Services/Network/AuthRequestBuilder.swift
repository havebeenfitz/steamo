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
        let parameters = "openid.mode=checkid_setup&openid.ns=http://specs.openid.net/auth/2.0&openid.op_endpoint=\(API.authURL)&openid.return_to=\(API.redirectURL)/&openid.identity=http://specs.openid.net/auth/2.0/identifier_select&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select&openid.realm=\(API.redirectURL)"
        
        var request = URLRequest(url: API.authURL)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        
        return request
    }
    
    /// Запрос на подтверждение авторизации
    /// - Parameter response: ответ сервера с предыдущего шага
    static func validationRequest(for response: URLResponse) -> URLRequest {
        let query = response.url?.query?.replacingOccurrences(of: "id_res", with: "check_authentication")
        var request = URLRequest(url: API.authURL)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = query?.data(using: .utf8)
        
        return request
    }
}
