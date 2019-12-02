//
//  SteamoLabel.swift
//  Steamo
//
//  Created by Max Kraev on 02.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit

/// Лэйбл с дефолтным заданным цветом
class SteamoLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        if #available(iOS 11.0, *) {
            textColor = UIColor(named: "Text")
        } else {
            textColor = .text
        }
    }
}
