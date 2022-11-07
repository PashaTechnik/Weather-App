//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit
import CoreLocation


class WeatherViewModel: NSObject {
    private var networkManager: NetworkManagerProtocol
    
    let locationManager = CLLocationManager()
    
    
    var reloadTableView: (() -> Void)?
    var reloadCollectionView: (() -> Void)?
    
    var forecastResult: Result!
    
    var weatherCellViewModels = [WeatherCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    var dayWeatherCellViewModels = [DayWeatherCellViewModel]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    var weatherModel: Dynamic<WeatherModel?> = Dynamic(nil)
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func initLocationManager() {
        self.locationManager.requestAlwaysAuthorization()

        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getForecastWithCoord(coord: Coord?) {
        
        if coord == nil {
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            networkManager.loadForecastWithCoord(lat: locValue.latitude, lon: locValue.longitude) { result in
                self.fetchData(result: result)
            }
        } else {
            networkManager.loadForecastWithCoord(lat: coord!.lat, lon: coord!.lon) { result in
                self.fetchData(result: result)
            }
        }
    }
    
    func getForecastWithCity(city: String) {
        networkManager.loadForecastWithCity(city: city) { result in
            self.fetchData(result: result)
        }
    }
    
    func fetchData(result: Result) {
        self.forecastResult = result
        initWeatherCell()
        initDayWeatherCell()
        initWeatherModel()
    }
    
    func initWeatherCell() {
        var weatherCellViewModel = [WeatherCellViewModel]()
        let forecasts = forecastResult.list.groupedBy(dateComponents: [.day, .month, .year]).sorted( by: { $0.0 < $1.0 })
        
        for forecast in forecasts {
            let day = forecast.value.first!.getDayFromDate()
            let min = forecast.value.map { $0.main.tempMin }.min()!
            let max = forecast.value.map { $0.main.tempMax }.max()!
            let icon = forecast.value.map({ $0.weather.first!.icon }).filter({ !$0.contains("n") }).mostFrequent() ?? "02d"
            
            weatherCellViewModel.append(WeatherCellViewModel(forecast: WeatherCellModel(day: day, minTemperature: min, maxTemperature: max, icon: icon)))
        }
        weatherCellViewModels = weatherCellViewModel
    }
    
    func initDayWeatherCell() {
        var dayWeatherCellViewModel = [DayWeatherCellViewModel]()
        let forecasts = forecastResult.list.prefix(10)
        
        for forecast in forecasts {
            let time = forecast.getHoursFromDate()
            let temperature = forecast.main.temp
            let icon = forecast.weather.first!.icon
            
            dayWeatherCellViewModel.append(DayWeatherCellViewModel(forecast: DayWeatherCellModel(time: time, temperature: temperature, icon: icon)))
        }
        dayWeatherCellViewModels = dayWeatherCellViewModel
    }
    
    func initWeatherModel() {
        let forecast = forecastResult.list.first!
        
        let date = forecast.getLocalizedDateFromDate()
        let icon = forecast.weather.first!.icon
        let minTemperature = forecast.main.tempMin
        let maxTemperature = forecast.main.tempMax
        let city = forecastResult.city.name
        let humidity = String(forecast.main.humidity) + "%"
        let windSpeed = String(Int(forecast.wind.speed)) + "м/с"
        let windDirection = "icon_wind_" + Utilities.getwindDirection(deg: forecast.wind.deg)
        let weather = WeatherModel(date: date, minTemperature: minTemperature, maxTemperature: maxTemperature, city: city, humidity: humidity, windSpeed: windSpeed, windDirection: windDirection, icon: icon)
        
        weatherModel.value = weather
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WeatherCellViewModel {
        return weatherCellViewModels[indexPath.row]
    }
    
    func getDayWeatherCellViewModel(at indexPath: IndexPath) -> DayWeatherCellViewModel {
        return dayWeatherCellViewModels[indexPath.row]
    }

}

extension WeatherViewModel: CLLocationManagerDelegate {

}
