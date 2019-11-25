//
//  ProfileViewModel.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    /// Состояние авторизации пользователя
    var isUserAuthorized: Bool {
        return steamId != nil
    }
    
    /// Стим айди игрока
    var steamId: String? {
        get { UserDefaults.standard.string(forKey: SteamoUserDefaultsKeys.steamId) }
        set { UserDefaults.standard.set(newValue, forKey: SteamoUserDefaultsKeys.steamId) }
    }
    
    /// Адаптер для работы с сетью
    private let networkAdapter: Networking
    
    /// Инициализватор по адаптеру
    /// - Parameter networkAdapter: адаптер для работы с сетью
    init(networkAdapter: Networking) {
        self.networkAdapter = networkAdapter
    }
    
    /// Получить сводную информацию по профилю
    /// - Parameter completion: колбэк по завершению запроса
    func profileSummary(completion: @escaping (Result<Profile, SteamoError>) -> Void) {
        networkAdapter.profileSummary { result in
            completion(result)
        }
    }
    
    func numberOfRowsIn(_ section: Int) -> Int {
        return 2
    }
    
    func logout() {
        steamId = nil
    }
}
