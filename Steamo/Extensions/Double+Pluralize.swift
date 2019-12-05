//
//  Double+Pluralize.swift
//  Steamo
//
//  Created by Max Kraev on 26.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

extension Int {
    func steamFormatted() -> String {
        if self == 0 || self == 1 {
            return "0 m"
        } else if self > 1, self < 120 {
            return "\(self) m"
        } else {
            return roundedHours()
        }
    }

    private func roundedHours() -> String {
        let hours = Double(self) / 60
        let roundedHours = (hours * 10).rounded() / 10
        return "\(roundedHours) h"
    }
}
