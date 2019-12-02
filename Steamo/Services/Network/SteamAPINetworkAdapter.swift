//
//  NetworkAdapter.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

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

    private let baseURL: URL = API.baseURL

    private var steamId: String? {
        UserDefaults.standard.string(forKey: SteamoUserDefaultsKeys.steamId)
    }

    func profileSummary(steamIds: [String], completion: @escaping (Swift.Result<Profiles, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUser/GetPlayerSummaries/v0002/")

        let parameters: JSON = ["key": API.apiKey,
                                "steamids": steamIds.joined(separator: ",")]

        Alamofire.request(url, method: .get, parameters: parameters)
            .responseData { response in
                switch response.result {
                case let .success(value):
                    do {
                        let profile = try JSONDecoder().decode(Profiles.self, from: value)
                        completion(.success(profile))
                    } catch {
                        completion(.failure(SteamoError.cantParseJSON))
                    }
                case .failure:
                    completion(.failure(SteamoError.noConnection))
                }
            }
    }

    func ownedGames(steamId: String, completion: @escaping (Swift.Result<Games, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("IPlayerService/GetOwnedGames/v0001/")
        let parameters: JSON = ["key": API.apiKey,
                                "steamid": steamId,
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

    func friends(steamId: String, completion: @escaping (Swift.Result<Friends, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUser/GetFriendList/v0001/")
        let parameters: JSON = ["key": API.apiKey,
                                "steamid": steamId,
                                "relationship": "friend"]

        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseData { response in
                switch response.result {
                case let .success(value):
                    do {
                        let friends = try JSONDecoder().decode(Friends.self, from: value)
                        completion(.success(friends))
                    } catch {
                        completion(.failure(SteamoError.cantParseJSON))
                    }
                case .failure:
                    completion(.failure(SteamoError.noConnection))
                }
            }
    }

    func recentlyPlayedGames(steamId: String, completion: @escaping (Swift.Result<Games, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("IPlayerService/GetRecentlyPlayedGames/v1/")
        let parameters: JSON = ["key": API.apiKey,
                                "steamid": steamId,
                                "count": 0,
                                "include_appinfo": true]

        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
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
    
    func gameSchema(for gameId: Int, completion: @escaping (Swift.Result<GameSchema, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUserStats/GetSchemaForGame/v2/")
        let parameters: JSON = ["key": API.apiKey,
                                "appid": gameId]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case let .success(value):
                    do {
                        let gameSchema = try JSONDecoder().decode(GameSchema.self, from: value)
                        completion(.success(gameSchema))
                    } catch {
                        print(error)
                        completion(.failure(SteamoError.cantParseJSON))
                    }
                case .failure:
                    completion(.failure(SteamoError.noConnection))
                }
        }
    }
    
    func stats(for gameId: Int, steamId: String, completion: @escaping (Swift.Result<PlayerStats, SteamoError>) -> Void) {
        let url = baseURL.appendingPathComponent("ISteamUserStats/GetUserStatsForGame/v0002/")
        let parameters: JSON = ["key": API.apiKey,
                                "steamid": steamId,
                                "appid": gameId]
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case let .success(value):
                    do {
                        let playerStats = try JSONDecoder().decode(PlayerStats.self, from: value)
                        completion(.success(playerStats))
                    } catch {
                        print(error)
                        completion(.failure(SteamoError.cantParseJSON))
                    }
                case .failure:
                    completion(.failure(SteamoError.noConnection))
                }
        }
    }
}
