//
//  ProfileViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {
    //MARK:- Public properties
    
    /// Состояние авторизации пользователя
    var isUserAuthorized: Bool {
        return steamId != nil
    }
    /// Стим айди игрока
    var steamId: String? {
        get { UserDefaults.standard.string(forKey: SteamoUserDefaultsKeys.steamId) }
        set { UserDefaults.standard.set(newValue, forKey: SteamoUserDefaultsKeys.steamId) }
    }
    /// Профиль пользователя
    var profile: Profile? = nil
    
    /// Игры пользователя
    var games: Games? = nil
    
    /// Друзья пользователя
    var friends: Friends? = nil
    
    //MARK:- Private properties
    
    private var cellViewModels: [ProfileCellViewModelRepresentable] = []
    
    /// Адаптер для работы с сетью
    private let networkAdapter: Networking
    
    /// Инициализватор по адаптеру
    /// - Parameter networkAdapter: адаптер для работы с сетью
    init(networkAdapter: Networking) {
        self.networkAdapter = networkAdapter
    }
    
    //MARK:- Methods
    
    /// Получить информацию по экрану
    /// - Parameter completion: колбэк по завершению запроса
    func loadProfile(completion: ((Result<Void, SteamoError>) -> Void)? = nil) {
        guard isUserAuthorized else { return }
        
        cellViewModels = []
        
        let chainDispatchGroup = DispatchGroup()
        
        chainDispatchGroup.enter()
        networkAdapter.profileSummary { [weak self] result in
            switch result {
            case let .success(profile):
                self?.profile = profile
                chainDispatchGroup.leave()
            case .failure:
                completion?(.failure(SteamoError.noConnection))
                chainDispatchGroup.leave()
            }
            
        }
        
        chainDispatchGroup.enter()
        networkAdapter.ownedGames { [weak self] result in
            switch result {
            case let .success(value):
                self?.games = value
                chainDispatchGroup.leave()
            case .failure:
                completion?(.failure(SteamoError.noConnection))
                chainDispatchGroup.leave()
            }
        }
        
        chainDispatchGroup.enter()
        networkAdapter.friends { [weak self] result in
            switch result {
            case let .success(value):
                self?.friends = value
                chainDispatchGroup.leave()
            case .failure:
                completion?(.failure(SteamoError.noConnection))
                chainDispatchGroup.leave()
            }
        }
        
        chainDispatchGroup.notify(queue: .main) {
            self.updateProfile()
            self.updateGames()
            self.updateFriends()
            self.sortSections()
            completion?(.success(()))
        }
    }
    
    private func updateProfile() {
        guard let profile = profile, let player = profile.response.players.first else {
            return
        }
        
        let avatarViewModel = AvatarCellViewModel(avatarURLString: player.avatarFull,
                                                  name: player.personaName,
                                                  status: UserStatus(rawValue: player.personaState) ?? .offline)
        cellViewModels.append(avatarViewModel)
    }
    
    private func updateGames() {
        guard let games = games else {
            return
        }
        
        let gamesViewModel = OwnedGamesCellViewModel(games: games)
        cellViewModels.append(gamesViewModel)
    }
    
    private func updateFriends() {
        guard let friends = friends else {
            return
        }
        
        
    }
    
    private func sortSections() {
        cellViewModels.sort(by: { $0.index < $1.index })
    }
    
    /// "Разлогиниться"
    func logout() {
        steamId = nil
        cellViewModels = []
    }
}

extension ProfileViewModel: UITableViewDelegate {
    
}

extension ProfileViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        cellViewModels[section].sectionTitle
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellViewModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = cellViewModels[indexPath.section]
        
        switch cellViewModel.type {
        case .avatar:
            if let cell: AvatarTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: cellViewModel)
                return cell
            }
        case .ownedGames:
            if let cell: OwnedGamesTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: cellViewModel)
                return cell
            }
        case .friends:
            if let cell: FriendsTableViewCell = tableView.dequeue(indexPath: indexPath) {
                cell.configure(with: cellViewModel)
                return cell
            }
        }
        assertionFailure("New cell")
        return UITableViewCell()
    }
    
    
}


