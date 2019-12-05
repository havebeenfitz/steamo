//
//  DatabaseManager.swift
//  Steamo
//
//  Created by Max Kraev on 05.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol DatabaseManagerProtocol {
    /// Сохранение одного объекта
    /// - Parameters:
    ///   - object: объект
    ///   - shouldUpdate: нужно ли обновлять существующий
    func save<T: Object>(_ object: T, shouldUpdate: Bool)
    /// Сохранение массива объектов
    /// - Parameters:
    ///   - collection: массив
    ///   - shouldUpdate: нужно ли обновлять существующий
    func save<T: Object>(_ collection: [T], shouldUpdate: Bool)
    /// Загрузить объекты определенного типа с опциональным фильтром
    /// - Parameters:
    ///   - objectType: Тип объекта для загрузки
    ///   - filter: Фильтр
    func load<T: Object>(objectType: T.Type, filter: ((T) -> Bool)?) -> [T]
}

class DatabaseManager: DatabaseManagerProtocol {
    
    private lazy var realm: Realm = {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError("Cannot instantiate Realm")
        }
    }()
    
    func save<T: Object>(_ object: T, shouldUpdate: Bool) {
        do {
            try realm.write {
                if shouldUpdate {
                    realm.add(object, update: .modified)
                } else {
                    realm.add(object)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func save<T: Object>(_ collection: [T], shouldUpdate: Bool) {
        do {
            try realm.write {
                if shouldUpdate {
                    realm.add(collection, update: .modified)
                } else {
                    realm.add(collection)
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    func load<T: Object>(objectType: T.Type, filter: ((T) -> Bool)?) -> [T] {
        let objects = realm.objects(objectType)
        var result: [T] = []
        if let filter = filter {
            result = objects.filter(filter)
            return result
        } else {
            return objects.map { object -> T in
                return object
            }
        }
    }
}
