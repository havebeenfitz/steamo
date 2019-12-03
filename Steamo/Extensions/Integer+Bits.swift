//
//  Integer+Bits.swift
//  Steamo
//
//  Created by Max Kraev on 03.12.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

import Foundation

enum Bit: UInt8, CustomStringConvertible {
    case zero, one

    var description: String {
        switch self {
        case .one:
            return "1"
        case .zero:
            return "0"
        }
    }
}

extension FixedWidthInteger {
    var bits: [Bit] {
        var bytes = self
        var bits = [Bit](repeating: .zero, count: self.bitWidth)
        for i in 0..<self.bitWidth {
            let currentBit = bytes & 0x01
            if currentBit != 0 {
                bits[i] = .one
            }

            bytes >>= 1
        }

        return bits
    }
}
