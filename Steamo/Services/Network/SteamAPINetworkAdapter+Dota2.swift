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
    /// Получить матчи юзера. За один заход отдает максимум 100
    /// - Parameters:
    ///   - steamId: id юзера
    ///   - limit: Количество матчей в запросе
    ///   - matchId: Оффсет
    ///   - completion: колбэк по завершению запроса
    func matches(for steamId: String, limit: Int, startFrom matchId: Int?, completion: @escaping (Swift.Result<MatchHistory, SteamoError>) -> Void)
    /// Получить детализацию матча по id
    /// - Parameters:
    ///   - matchId: id матча
    ///   - completion: колбэк по завершению запроса
    func matchDetails(for matchId: Int, completion: @escaping (Swift.Result<MatchDetails, SteamoError>) -> Void)
}

extension SteamAPINetworkAdapter: Dota2APINetworkAdapterProtocol {
    func matches(for steamId: String, limit: Int, startFrom matchId: Int? = nil, completion: @escaping (Swift.Result<MatchHistory, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("IDOTA2Match_570/GetMatchHistory/v001/")
        var parameters = defaultParams
        parameters["account_id"] = steamId
        parameters["matches_requested"] = limit
        if let matchId = matchId {
            parameters["start_at_match_id"] = matchId
        }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
        }
    }
    
    func matchDetails(for matchId: Int, completion: @escaping (Swift.Result<MatchDetails, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("IDOTA2Match_570/GetMatchDetails/v001/")
        var parameters = defaultParams
        parameters["match_id"] = matchId
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
        }
    }
}
