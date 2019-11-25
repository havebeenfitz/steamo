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
    
    //MARK:- Private properties
    
    private var cellViewModels: [ProfileCellViewModel] = []
    
    /// Адаптер для работы с сетью
    private let networkAdapter: Networking
    
    /// Инициализватор по адаптеру
    /// - Parameter networkAdapter: адаптер для работы с сетью
    init(networkAdapter: Networking) {
        self.networkAdapter = networkAdapter
    }
    
    //MARK:- Methods
    
    /// Получить сводную информацию по профилю
    /// - Parameter completion: колбэк по завершению запроса
    func profileSummary(completion: @escaping (Result<Void, SteamoError>) -> Void) {
        cellViewModels = []
        networkAdapter.profileSummary { [weak self] result in
            switch result {
            case let .success(profile):
                self?.profile = profile
                self?.updateProfile()
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
            
        }
    }
    
    private func updateProfile() {
        if let profile = profile, let player = profile.response.players.first {
            let avatarViewModel = AvatarCellViewModel(avatarURLString: player.avatarFull,
                                                      name: player.personaName,
                                                      status: UserStatus(rawValue: player.personaState) ?? .offline)
            cellViewModels.append(avatarViewModel)
        }
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
        case .gamesBought:
            return UITableViewCell()
        }
        assertionFailure("New cell")
        return UITableViewCell()
    }
    
    
}


