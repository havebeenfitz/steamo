//
//  Array+Safe.swift
//  Steamo
//
//  Created by Max Kraev on 27.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

extension Array {
    /// Метод для безопасного извлечения/добавления элементов по индексу из массива
    /// В случае если индекс находится за пределами текущего диапозона - вернется nil или сработает assert
    ///
    /// - Parameter index: Индекс элемента
    subscript(safe index: Index) -> Iterator.Element? {
        get {
            if indices ~= index {
                return self[index]
            }
            return nil
        }
        set {
            if indices ~= index, let value = newValue {
                self[index] = value
            }
        }
    }
}
