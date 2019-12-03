//
//  SteamoError.swift
//  Steamo
//
//  Created by Max Kraev on 25.11.2019.
//  Copyright © 2019 Max Kraev. All rights reserved.
//

/// Ошибки приложения
enum SteamoError: Error {
    case cantParseJSON
    case noConnection
    case noData
}
