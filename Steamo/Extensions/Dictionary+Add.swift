//
//  Dictionary+Add.swift
//  Steamo
//
//  Created by Max Kraev on 05.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

extension Dictionary {
    @discardableResult
    static func + (lhs: inout Dictionary, rhs: Dictionary) -> Dictionary {
        for key in rhs.keys {
            lhs[key] = rhs[key]
        }
        
        return lhs
    }
}
