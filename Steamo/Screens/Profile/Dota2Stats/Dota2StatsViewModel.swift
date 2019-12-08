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
    /// Id матчей игрока
    ///
    /// Маленький хак. Т.к. пэйджинг реализован от последнего матча, мы получаем один и тот же матч на следующией странице.
    /// Последний == первый. Сет позволяет исключить дубликаты
    var matchIds: Set<Int> = Set()
    /// Массив детализаций по матчу
    var matchDetailsCollection: [MatchDetails] = []
    
    private var resultsRemaining: Int = 1
    private var lastMatchId: Int?
    private var loadDataWorkItem: DispatchWorkItem?
    
    private let databaseManager: DatabaseManagerProtocol
    private let networkAdapter: Dota2APINetworkAdapterProtocol
    private let steamId: String
    
    init(databaseManager: DatabaseManagerProtocol, networkAdapter: Dota2APINetworkAdapterProtocol, steamId: String) {
        self.databaseManager = databaseManager
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
                            self?.matchIds.insert(match.matchId)
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
            guard !self.matchIds.isEmpty else {
                self.appendErrorSection()
                completion(.failure(.noData))
                return
            }
            
            let matches: [Dota2MatchResult] = self.databaseManager.load(filter: { $0.ownerSteamId == self.steamId })
            let existingMatchIds: Set<Int> = Set(matches.map { $0.matchId })
            
            let missingMatchIds = self.matchIds.subtracting(existingMatchIds)
            
            if missingMatchIds.isEmpty {
                self.appendSections()
                completion(.success(()))
                return
            }
            
            // Тут мы немного рискуем, но сервер вроде переваривает по 10 запросов за раз
            let semaphore = DispatchSemaphore(value: 10)
            
            for (index, matchId) in missingMatchIds.enumerated() {
                if self.loadDataWorkItem?.isCancelled ?? false { break }
                semaphore.wait()
                self.networkAdapter.matchDetails(for: matchId) { [weak self] result in
                    guard let self = self else {
                        completion(.failure(.noData))
                        semaphore.signal()
                        return
                    }
                    switch result {
                    case let .success(matchDetails):
                        self.matchDetailsCollection.append(matchDetails)
                        if !(self.loadDataWorkItem?.isCancelled ?? false) {
                            progress(Float(self.matchDetailsCollection.count) / Float(missingMatchIds.count))
                        }
                        if index == missingMatchIds.count - 1 {
                            self.saveToDB(self.matchDetailsCollection)
                            self.appendSections()
                            completion(.success(()))
                        }
                        semaphore.signal()
                    case .failure(_):
                        if index == missingMatchIds.count - 1 && self.matchDetailsCollection.isEmpty {
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
    
    private func saveToDB(_ matchDetails: [MatchDetails]) {
        let matchResults = matchDetails.map { detail -> Dota2MatchResult in
            return Dota2MatchResult(ownerSteamId: steamId, matchResult: detail.result)
        }
        databaseManager.save(matchResults, shouldUpdate: true)
    }
    
    private func appendSections() {
        reset()
        
        let winRateSection = WinRateSectionViewModel(databaseManager: databaseManager,
                                                     steamId: steamId)
        let matchesByDateSection = MatchesByDateSectionViewModel(databaseManager: databaseManager,
                                                                 steamId: steamId)
        sectionViewModels.append(winRateSection)
        sectionViewModels.append(matchesByDateSection)
    }
    
    private func appendErrorSection() {
        reset()
        sectionViewModels.append(Dota2ErrorSectionViewModel())
    }
    
    // Сброс состояния, используется при рефреше 
    private func reset() {
        resultsRemaining = 1
        lastMatchId = nil
        sectionViewModels = []
    }
}
