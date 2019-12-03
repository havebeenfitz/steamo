//
//  Dota2StatsViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class Dota2StatsViewModel {
    
    var matchHistory: MatchHistory?
    var matchDetailsCollection: [MatchDetails] = []
    
    var sectionViewModels: [Dota2StatsSectionViewModelRepresentable] = []
    
    private let networkAdapter: Dota2APINetworkAdapterProtocol
    private let steamId: String
    
    init(networkAdapter: Dota2APINetworkAdapterProtocol, steamId: String) {
        self.networkAdapter = networkAdapter
        self.steamId = steamId
    }
    
    func fetch(completion: @escaping (Result<Void, SteamoError>) -> Void) {
        let chainDispatchGroup = DispatchGroup()
        
        chainDispatchGroup.enter()
        networkAdapter.matches(for: steamId, limit: 30) { [weak self] result in
            switch result {
            case let .success(matchHistory):
                self?.matchHistory = matchHistory
                chainDispatchGroup.leave()
            case let .failure(error):
                print(error)
                chainDispatchGroup.leave()
            }
        }
        
        let workItem = DispatchWorkItem(qos: .utility) {
            guard let matchHistory = self.matchHistory, let matches = matchHistory.result.matches else {
                completion(.failure(SteamoError.noData))
                return
            }
            
            let semaphore = DispatchSemaphore(value: 1)
            
            for (index, match) in matches.enumerated() {
                semaphore.wait()
                self.networkAdapter.matchDetails(for: match.matchId) { [weak self] result in
                    guard let self = self else {
                        completion(.failure(.noConnection))
                        semaphore.signal()
                        return
                    }
                    switch result {
                    case let .success(matchDetails):
                        self.matchDetailsCollection.append(matchDetails)
                        if index == matches.count - 1 {
                            let totalWinsSection = TotalWinsSectionViewModel(matchDetailsCollection: self.matchDetailsCollection,
                                                                             steamId: self.steamId)
                            self.sectionViewModels.append(totalWinsSection)
                            completion(.success(()))
                        }
                        semaphore.signal()
                    case .failure(_):
                        if index == matches.count - 1 && self.matchDetailsCollection.isEmpty {
                            completion(.failure(.noConnection))
                        }
                        semaphore.signal()
                    }
                }
            }
        }
        
        chainDispatchGroup.notify(queue: .global(qos: .utility), work: workItem)
    }
}
