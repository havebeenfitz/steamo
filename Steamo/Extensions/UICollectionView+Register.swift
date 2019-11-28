//
//  UICollectionView+Register.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func register(class: UICollectionViewCell.Type) {
        register(`class`, forCellWithReuseIdentifier: String(describing: `class`))
    }

    func dequeue<RegisteredCell: UICollectionViewCell>(indexPath: IndexPath) -> RegisteredCell? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: RegisteredCell.self),
                                   for: indexPath) as? RegisteredCell
    }

    func cell<RegisteredCell: UICollectionViewCell>(for indexPath: IndexPath) -> RegisteredCell? {
        return cellForItem(at: indexPath) as? RegisteredCell
    }
}
