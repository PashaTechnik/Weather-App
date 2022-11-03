//
//  String+countryName.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation


extension String {
    func countryName() -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: self)
    }
}

