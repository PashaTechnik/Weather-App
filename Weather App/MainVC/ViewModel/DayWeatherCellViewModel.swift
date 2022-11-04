//
//  DayWeatherCellViewModel.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation
import UIKit

class DayWeatherCellViewModel {
    
    private var forecast: DayWeatherCellModel
    
    var time: String {
        return "\(forecast.time)⁰⁰"
    }
    
    var temperature: String {
        return "\(forecast.temperature)°"
    }
    
    var forecastIcon: UIImage {
        return UIImage(named: Utilities.iconDict[forecast.icon, default: "ic_white_day_bright"]) ?? UIImage()
    }
    
    
    init(forecast: DayWeatherCellModel) {
        self.forecast = forecast
    }
}
