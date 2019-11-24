//
//  SteamoButton.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import UIKit


class SteamoButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            scale(isHighlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func scale(_ shouldScale: Bool) {
        if shouldScale {
            transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        } else {
            transform = .identity
        }
    }
}
