//
//  UITableView+Register.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

public extension UITableView {
     func register(class: UITableViewCell.Type) {
        register(`class`, forCellReuseIdentifier: String(describing: `class`))
     }

     func dequeue<RegisteredCell: UITableViewCell>(indexPath: IndexPath) -> RegisteredCell? {
        return dequeueReusableCell(withIdentifier: String(describing: RegisteredCell.self),
                                   for: indexPath) as? RegisteredCell
     }

     func cell<RegisteredCell: UITableViewCell>(for indexPath: IndexPath) -> RegisteredCell? {
        return cellForRow(at: indexPath) as? RegisteredCell
     }
}
