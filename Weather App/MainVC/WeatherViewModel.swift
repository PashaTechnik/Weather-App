//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit


class WeatherViewModel {
    private var networkManager: NetworkManagerProtocol
    
    var reloadTableView: (() -> Void)?
    
    var forecastResult: Result
    
    var weatherCellViewModels = [WeatherCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getForecast() {
        networkManager.loadForecast { result in
            if let result = result {
                self.fetchData(employees: employees)
            }
        }
    }
    
    func fetchData(result: Result) {
        self.forecastResult = result
        var weatherCellViewModel = [WeatherCellViewModel]()
//        for employee in employees {
//            vms.append(createCellModel(employee: employee))
//        }
        weatherCellViewModels = weatherCellViewModel
    }
    
//    func createCellModel(employee: Employee) -> EmployeeCellViewModel {
//        let id = employee.id
//        let name = employee.employeeName
//        let salary = "$ " + employee.employeeSalary
//        let age = employee.employeeAge
//
//        return EmployeeCellViewModel(id: id, name: name, salary: salary, age: age)
//    }
//
//    func getCellViewModel(at indexPath: IndexPath) -> EmployeeCellViewModel {
//        return employeeCellViewModels[indexPath.row]
//    }

}


class EmployeesViewModel: NSObject {

}
