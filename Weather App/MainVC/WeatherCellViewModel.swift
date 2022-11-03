//
//  WeatherCellViewModel.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation
import UIKit

class WeatherCellViewModel {
    
    private var forecast: WeatherCellModel
    
    var day: String {
        return forecast.day
    }
    
    var temperature: String {
        return "\(forecast.minTemperature)° / \(forecast.maxTemperature)°"
    }
    
    var forecastIcon: UIImage {
        return UIImage(named: iconDict[forecast.icon, default: "ic_white_day_bright"]) ?? UIImage()
    }
    
    private let iconDict: [String : String] = [
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
    
    init(forecast: WeatherCellModel) {
        self.forecast = forecast
    }
}
