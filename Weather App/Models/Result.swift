//
//  Result.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation


struct Result: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}
