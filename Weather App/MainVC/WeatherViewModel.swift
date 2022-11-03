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
    
    var forecastResult: Result!
    
    var weatherCellViewModels = [WeatherCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
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
    
    func getForecast() {
        networkManager.loadForecast { result in
            self.fetchData(result: result)
        }
    }
    
    func fetchData(result: Result) {
        self.forecastResult = result
        var weatherCellViewModel = [WeatherCellViewModel]()
        let forecasts = result.list.groupedBy(dateComponents: [.day, .month, .year]).sorted( by: { $0.0 < $1.0 })
        
        for forecast in forecasts {
            let day = forecast.value.first!.getDayFromDate()
            let min = forecast.value.map { $0.main.tempMin }.min()!
            let max = forecast.value.map { $0.main.tempMax }.max()!
            let icon = forecast.value.map({ $0.weather.first!.icon }).filter({ !$0.contains("n") }).mostFrequent()!
            
            weatherCellViewModel.append(WeatherCellViewModel(forecast: WeatherCellModel(day: day, minTemperature: min, maxTemperature: max, icon: icon)))
        }
        weatherCellViewModels = weatherCellViewModel
        
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> WeatherCellViewModel {
        return weatherCellViewModels[indexPath.row]
    }

}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
