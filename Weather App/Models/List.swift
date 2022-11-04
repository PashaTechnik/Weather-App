//
//  List.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation


struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
    
    func getDayFromDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date)
    }
    
    func getHoursFromDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return String(hour)
    }
    
    func getLocalizedDateFromDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EE, d MMMM"
        return dateFormatter.string(from: date)
    }
    
}

extension List: Dated {
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(dt))
    }
}
