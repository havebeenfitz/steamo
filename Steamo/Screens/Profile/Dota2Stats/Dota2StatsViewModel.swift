//
//  Dota2StatsViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class Dota2StatsViewModel {
    /// Массив вьюмоделей секций
    var sectionViewModels: [Dota2StatsSectionViewModelRepresentable] = []
    /// История Матчей
    var matchHistory: MatchHistory?
    /// Все матчи игрока. Нужны, чтобы забрать id и передать их в эндпоинт детализации
    ///
    /// Маленький хак. Т.к. пэйджинг реализован от последнего матча, мы получаем один и тот же матч на следующией странице.
    /// Последний == первый. Сет позволяет исключить дубликаты
    var matches: Set<Match> = Set()
    /// Массив детализаций по матчу
    var matchDetailsCollection: [MatchDetails] = []
    
    private var resultsRemaining: Int = 1
    private var lastMatchId: Int?
    private var loadDataWorkItem: DispatchWorkItem?
    
    private let networkAdapter: Dota2APINetworkAdapterProtocol
    private let steamId: String
    
    init(networkAdapter: Dota2APINetworkAdapterProtocol, steamId: String) {
        self.networkAdapter = networkAdapter
        self.steamId = steamId
    }
    
    /// Получить данные по матчам
    /// Сначала запрашивается история матчей, далее все матчи пачками по 5
    /// - Parameters:
    ///   - progress: Прогресс операции для показа на лоадере
    ///   - completion: блок по завершению запроса
    func fetch(progress: @escaping (Float) -> Void, completion: @escaping (Result<Void, SteamoError>) -> Void) {
        // Диспатч группа для нотификации о том, что история матчей загрузилась
        let chainDispatchGroup = DispatchGroup()
        // Семафор, чтобы запросы на историю выполнялись последовательно
        let semaphore = DispatchSemaphore(value: 1)
        /// Отдельная очередь на запрос истории, чтобы не словить дэдлок
        let downloadQueue = DispatchQueue.init(label: "DownloadQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: DispatchQueue.global())
        
        downloadQueue.async(group: chainDispatchGroup, qos: .background, flags: .inheritQoS) {
            while self.resultsRemaining > 0 {
                chainDispatchGroup.enter()
                semaphore.wait()
                self.networkAdapter.matches(for: self.steamId, limit: 100, startFrom: self.lastMatchId) { [weak self] result in
                    switch result {
                    case let .success(matchHistory):
                        self?.matchHistory = matchHistory
                        for match in matchHistory.result.matches ?? [] {
                            self?.matches.insert(match)
                        }
                        self?.resultsRemaining = matchHistory.result.resultsRemaining ?? 0
                        self?.lastMatchId = matchHistory.result.matches?.last?.matchId
                        chainDispatchGroup.leave()
                        semaphore.signal()
                    case .failure:
                        self?.resultsRemaining = 0
                        chainDispatchGroup.leave()
                        semaphore.signal()
                    }
                }
            }
        }
        
        
        loadDataWorkItem = DispatchWorkItem(qos: .utility) {
            guard !self.matches.isEmpty else {
                self.sectionViewModels.append(Dota2ErrorSectionViewModel())
                completion(.failure(SteamoError.noData))
                return
            }
            
            // Тут мы немного рискуем, но сервер вроде переваривает по 5 запросов за раз
            let semaphore = DispatchSemaphore(value: 5)
            
            for (index, match) in self.matches.enumerated() {
                if self.loadDataWorkItem?.isCancelled ?? false { break }
                semaphore.wait()
                self.networkAdapter.matchDetails(for: match.matchId) { [weak self] result in
                    guard let self = self else {
                        completion(.failure(.noData))
                        semaphore.signal()
                        return
                    }
                    switch result {
                    case let .success(matchDetails):
                        self.matchDetailsCollection.append(matchDetails)
                        if !(self.loadDataWorkItem?.isCancelled ?? false) {
                            progress(Float(self.matchDetailsCollection.count) / Float(self.matches.count))
                        }
                        if index == self.matches.count - 1 {
                            let winRateSection = WinRateSectionViewModel(matchDetailsCollection: self.matchDetailsCollection,
                                                                             steamId: self.steamId)
                            let matchesByDateSection = MatchesByDateSectionViewModel(matchDetailsCollection: self.matchDetailsCollection,
                                                                                  steamId: self.steamId)
                            self.sectionViewModels.append(winRateSection)
                            self.sectionViewModels.append(matchesByDateSection)
                            completion(.success(()))
                        }
                        semaphore.signal()
                    case .failure(_):
                        if index == self.matches.count - 1 && self.matchDetailsCollection.isEmpty {
                            completion(.failure(.noData))
                        } else {
                            semaphore.signal()
                        }
                    }
                }
            }
        }
        
        if let workItem = loadDataWorkItem {
            chainDispatchGroup.notify(queue: .global(qos: .utility), work: workItem)
        } else {
            completion(.failure(.noData))
        }
    }
    
    /// Отменить загрузку при выходе с экрана
    func cancelRequest() {
        loadDataWorkItem?.cancel()
    }
}
