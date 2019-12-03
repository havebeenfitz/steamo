//
//  SteamAPINetworkAdapter+Dota2.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Alamofire
import Foundation

protocol Dota2APINetworkAdapterProtocol {
    /// Получить матчи юзера
    /// - Parameters:
    ///   - steamId: id юзера
    ///   - limit: Количество матчей в запросе
    ///   - completion: колбэк по завершению запроса
    func matches(for steamId: String, limit: Int, completion: @escaping (Swift.Result<MatchHistory, SteamoError>) -> Void)
    /// Получить детализацию матча по id
    /// - Parameters:
    ///   - matchId: id матча
    ///   - completion: колбэк по завершению запроса
    func matchDetails(for matchId: String, completion: @escaping (Swift.Result<MatchDetails, SteamoError>) -> Void)
}

extension SteamAPINetworkAdapter: Dota2APINetworkAdapterProtocol {
    func matches(for steamId: String, limit: Int, completion: @escaping (Swift.Result<MatchHistory, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("IDOTA2Match_570/GetMatchHistory/v001/")
        var parameters = defaultParams
        parameters["account_id"] = steamId
        parameters["matches_requested"] = limit
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
        }
    }
    
    func matchDetails(for matchId: String, completion: @escaping (Swift.Result<MatchDetails, SteamoError>) -> Void) {
        
    }
}
