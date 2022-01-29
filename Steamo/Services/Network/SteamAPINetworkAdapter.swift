//
//  NetworkAdapter.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation
import Alamofire

protocol SteamAPINetworkAdapterProtocol {
    /// Получить сводную информацию по профилю
    /// - Parameter steamIds: Список идентификаторов стима
    /// - Parameter completion: колбэк по завершению запроса
    func profileSummary(steamIds: [String], completion: @escaping (Swift.Result<Profiles, SteamoError>) -> Void)

    /// Получить список игр пользователя
    /// - Parameter steamId: идентификатор пользователя в стиме
    /// - Parameter completion: колбэк по завершению запроса
    func ownedGames(steamId: String, completion: @escaping (Swift.Result<Games, SteamoError>) -> Void)

    /// Получить список друзей
    /// - Parameter steamId: идентификатор пользователя в стиме
    /// - Parameter completion: колбэк по завершению запроса
    func friends(steamId: String, completion: @escaping (Swift.Result<Friends, SteamoError>) -> Void)

    /// Получить список недавно сыгранных игр
    /// - Parameter steamId: идентификатор пользователя в стиме
    /// - Parameter completion: колбэк по завершению запроса
    func recentlyPlayedGames(steamId: String, completion: @escaping (Swift.Result<Games, SteamoError>) -> Void)
    
    /// Схема с названием ачивок и статов для конкретной игры
    /// - Parameters:
    ///   - gameId: идентификатор игры
    ///   - completion: колбэк по завершению запроса
    func gameSchema(for gameId: Int, completion: @escaping (Swift.Result<GameSchema, SteamoError>) -> Void)
    
    /// Статистика юзера по конкретной игре
    /// - Parameters:
    ///   - gameId: идентификатор игры
    ///   - steamId: идентификатор юзера
    ///   - completion: колбэк по завершению запроса
    func stats(for gameId: Int, steamId: String, completion: @escaping (Swift.Result<PlayerStats, SteamoError>) -> Void)
}

class SteamAPINetworkAdapter: SteamAPINetworkAdapterProtocol {
    typealias JSON = [String: Any]

    let baseURL: URL = API.baseURL
    
    var defaultParams: JSON = ["key": API.apiKey]

    func profileSummary(steamIds: [String], completion: @escaping (Swift.Result<Profiles, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUser/GetPlayerSummaries/v0002/")

        var parameters = defaultParams
        parameters["steamids"] = steamIds.joined(separator: ",")

        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
            }
    }

    func ownedGames(steamId: String, completion: @escaping (Swift.Result<Games, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("IPlayerService/GetOwnedGames/v0001/")
        var parameters = defaultParams
        parameters["steamid"] = steamId
        parameters["include_appinfo"] = true

        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString,
                                                                                           arrayEncoding: .brackets,
                                                                                           boolEncoding: .literal))
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
            }
    }

    func friends(steamId: String, completion: @escaping (Swift.Result<Friends, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUser/GetFriendList/v0001/")
        var parameters = defaultParams
        parameters["steamid"] = steamId
        parameters["relationship"] = "friend"

        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
            }
    }

    func recentlyPlayedGames(steamId: String, completion: @escaping (Swift.Result<Games, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("IPlayerService/GetRecentlyPlayedGames/v1/")
        var parameters: JSON = defaultParams
        parameters["steamid"] = steamId
        parameters["count"] = 100
        parameters["include_appinfo"] = true

        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
            }
    }
    
    func gameSchema(for gameId: Int, completion: @escaping (Swift.Result<GameSchema, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUserStats/GetSchemaForGame/v2/")
        var parameters: JSON = defaultParams
        parameters["appid"] = gameId
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
        }
    }
    
    func stats(for gameId: Int, steamId: String, completion: @escaping (Swift.Result<PlayerStats, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUserStats/GetUserStatsForGame/v0002/")
        var parameters: JSON = defaultParams
        parameters["steamid"] = steamId
        parameters["appid"] = gameId
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
        }
    }
}

extension SteamAPINetworkAdapter {
    func handleResponse<T: Codable>(response: AFDataResponse<Data>, completion: (Swift.Result<T, SteamoError>) -> Void) {
        switch response.result {
        case let .success(value):
            do {
                let object = try JSONDecoder().decode(T.self, from: value)
                completion(.success(object))
            } catch {
                print(error)
                completion(.failure(SteamoError.cantParseJSON))
            }
        case .failure:
            completion(.failure(SteamoError.noConnection))
        }
    }
}
