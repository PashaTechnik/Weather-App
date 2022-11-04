//
//  Utilities.swift
//  Weather App
//
//  Created by Pasha on 04.11.2022.
//

import Foundation


class Utilities {
    static let iconDict: [String : String] = [
        "01d": "ic_white_day_bright",
        "02d": "ic_white_day_cloudy",
        "03d": "ic_white_day_cloudy",
        "04d": "ic_white_day_cloudy",
        "09d": "ic_white_day_rain",
        "10d": "ic_white_day_shower",
        "11d": "ic_white_day_thunder",
        "01n": "ic_white_night_bright",
        "02n": "ic_white_night_cloudy",
        "03n": "ic_white_day_cloudy",
        "04n": "ic_white_day_cloudy",
        "10n": "ic_white_night_rain",
        "09n": "ic_white_night_shower",
        "11n": "ic_white_night_thunder"]
    
    static func getwindDirection(deg: Int) -> String {
        switch deg {
        case 0..<23:
            return "n"
        case 23..<68:
            return "ne"
        case 68..<113:
            return "e"
        case 113..<158:
            return "se"
        case 158..<203:
            return "s"
        case 203..<248:
            return "ws"
        case 248..<293:
            return "w"
        case 293..<336:
            return "wn"
        case 336..<360:
            return "n"
        default:
            return "n"
        }
    }


}
