//
//  DefaultTableViewCell.swift
//  Steamo
//
//  Created by Max Kraev on 06.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        if #available(iOS 11.0, *) {
            textLabel?.textColor = UIColor(named: "Text")
        } else {
            textLabel?.textColor = .text
        }
    }
}
