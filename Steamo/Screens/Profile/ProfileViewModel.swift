//
//  ProfileViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {
    
    /// Состояние экрана
    enum State {
        /// Пользователь
        case you
        /// Друг (друг друга и т.д.)
        case friend(steamId: String)
    }
    
    //MARK:- Public properties
    
    /// Заголовок экрана
    var screenTitle: String {
        switch state {
        case .you:
            return "Profile"
        case .friend:
            return "Friend"
        }
    }
    
    /// Состояние авторизации пользователя
    var isUserAuthorized: Bool {
        return steamId != nil
    }
    /// Стим айди игрока
    var steamId: String? {
        get { UserDefaults.standard.string(forKey: SteamoUserDefaultsKeys.steamId) }
        set { UserDefaults.standard.set(newValue, forKey: SteamoUserDefaultsKeys.steamId) }
    }
    
    /// Вьюмодели секций
    var sectionViewModels: [ProfileSectionViewModelRepresentable] = []
    
    //MARK:- Private properties
    
    /// Состояние экрана
    private var state: State
    
    /// Профиль пользователя
    private var profiles: Profiles? = nil
    
    /// Профили друзей
    private var friendsProfiles: Profiles? = nil
    
    /// Игры пользователя
    private var games: Games? = nil
    
    /// Друзья пользователя
    private var friends: Friends? = nil
    
    /// Адаптер для работы с сетью
    private let networkAdapter: SteamAPINetworkAdapterProtocol
    
    /// Инициализватор по адаптеру
    /// - Parameter networkAdapter: адаптер для работы с сетью
    init(networkAdapter: SteamAPINetworkAdapterProtocol, state: State) {
        self.networkAdapter = networkAdapter
        self.state = state
    }
    
    //MARK:- Methods
    
    /// Получить информацию по экрану
    /// - Parameter completion: колбэк по завершению запроса
    func loadProfile(completion: ((Result<Void, SteamoError>) -> Void)? = nil) {
    
        sectionViewModels = []
        
        let chainDispatchGroup = DispatchGroup()
        
        let steamId: String
        
        switch state {
        case .you:
            steamId = self.steamId ?? "noSteamId"
        case let .friend(steamId: friendSteamId):
            steamId = friendSteamId
        }
        
        chainDispatchGroup.enter()
        networkAdapter.profileSummary(steamIds: [steamId]) { [weak self] result in
            switch result {
            case let .success(profiles):
                self?.profiles = profiles
                chainDispatchGroup.leave()
            case .failure:
                chainDispatchGroup.leave()
            }
            
        }
        
        chainDispatchGroup.enter()
        networkAdapter.ownedGames(steamId: steamId) { [weak self] result in
            switch result {
            case let .success(value):
                self?.games = value
                chainDispatchGroup.leave()
            case .failure:
                chainDispatchGroup.leave()
            }
        }
        
        chainDispatchGroup.enter()
        networkAdapter.friends(steamId: steamId) { [weak self] result in
            switch result {
            case let .success(value):
                self?.friends = value
                chainDispatchGroup.leave()
            case .failure:
                chainDispatchGroup.leave()
            }
        }
        
        let workItem = DispatchWorkItem {
            guard let friends = self.friends else { return }
            let steamIds = friends.friendsList.friends.map { $0.steamId }
            
            self.networkAdapter.profileSummary(steamIds: steamIds) { [weak self] result in
                switch result {
                case let .success(profiles):
                    self?.friendsProfiles = profiles
                    
                    self?.updateData()
                    
                    completion?(.success(()))
                case let .failure(error):
                    completion?(.failure(error))
                }
            }
        }
        
        chainDispatchGroup.notify(queue: .main, work: workItem)
    }
    
    private func updateData() {
        updateProfile()
        updateGames()
        updateFriends()
        sortSections()
    }
    
    private func updateProfile() {
        guard let profiles = profiles else {
            return
        }
        
        let avatarViewModel = AvatarCellViewModel(profiles: profiles)
        sectionViewModels.append(avatarViewModel)
    }
    
    private func updateGames() {
        guard let games = games else {
            return
        }
        
        let gamesViewModel = OwnedGamesCellViewModel(games: games)
        sectionViewModels.append(gamesViewModel)
    }
    
    private func updateFriends() {
        guard let friendsProfiles = friendsProfiles else {
            return
        }
        
        let friendsSectionViewModel = FriendsSectionViewModel(profiles: friendsProfiles)
        sectionViewModels.append(friendsSectionViewModel)
    }
    
    private func sortSections() {
        sectionViewModels.sort(by: { $0.index < $1.index })
    }
    
}
