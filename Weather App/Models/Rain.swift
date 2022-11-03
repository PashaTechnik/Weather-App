//
//  Rain.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation

struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}
