//
//  Weather.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

