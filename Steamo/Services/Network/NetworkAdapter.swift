//
//  NetworkAdapter.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Alamofire

protocol Networking {
    /// Получить сводную информацию по профилю
    /// - Parameter completion: колбэк по завершению запроса
    func profileSummary(completion: @escaping (Swift.Result<Profile, SteamoError>) -> Void)
    
    func ownedGames(completion: @escaping (Swift.Result<Games, SteamoError>) -> Void)
}

class NetworkAdapter: Networking {
    
    
    
    typealias JSON = [String: Any]
    
    private let baseURL: URL = API.baseURL
    
    private var steamId: String? {
        UserDefaults.standard.string(forKey: SteamoUserDefaultsKeys.steamId)
    }
    
    func profileSummary(completion: @escaping (Swift.Result<Profile, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUser/GetPlayerSummaries/v0002/")
        
        let parameters: JSON = ["key": API.apiKey,
                                "steamids": steamId ?? ""]
        
        
        Alamofire.request(url, method: .get, parameters: parameters)
            .responseData { response in
                switch response.result {
                case let .success(value):
                    do {
                        let profile = try JSONDecoder().decode(Profile.self, from: value)
                        completion(.success(profile))
                    } catch {
                        completion(.failure(SteamoError.cantParseJSON))
                    }
                case .failure:
                    completion(.failure(SteamoError.noConnection))
                }
        }
    }
    
    func ownedGames(completion: @escaping (Swift.Result<Games, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("IPlayerService/GetOwnedGames/v0001/")
        let parameters: JSON = ["key": API.apiKey,
                                "steamid": steamId ?? "",
                                "include_appinfo": true]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString,
                                                                                           arrayEncoding: .brackets,
                                                                                           boolEncoding: .literal))
            .responseData { response in
                switch response.result {
                case let .success(value):
                    do {
                        let games = try JSONDecoder().decode(Games.self, from: value)
                        completion(.success(games))
                    } catch {
                        completion(.failure(SteamoError.cantParseJSON))
                    }
                case .failure:
                    completion(.failure(SteamoError.noConnection))
                }
        }
    }
}
