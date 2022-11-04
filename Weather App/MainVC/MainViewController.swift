//
//  MainViewController.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var dayWeatherCollectionView: UICollectionView!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirection: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    lazy var viewModel = {
        WeatherViewModel()
    }()
    
    var userCoordinates: Coord? = nil {
        didSet {
            initViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        dayWeatherCollectionView.delegate = self
        dayWeatherCollectionView.dataSource = self
    }

    func initViewModel() {
        
        viewModel.getForecast(coord: userCoordinates)
        viewModel.initLocationManager()
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.weatherTableView.reloadData()
            }
        }
        
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.dayWeatherCollectionView.reloadData()
            }
        }
        
        viewModel.weatherModel.bind { weatherModel in
            DispatchQueue.main.async {
                self.dateLabel.text = weatherModel?.date
                self.cityNameLabel.text = weatherModel?.city
                self.humidityValueLabel.text = weatherModel?.humidity
                self.temperatureValueLabel.text = "\(String(Int(weatherModel!.minTemperature)))° / \(String(Int(weatherModel!.maxTemperature)))°"
                self.weatherIcon.image = UIImage(named: Utilities.iconDict[weatherModel!.icon, default: "ic_white_day_bright"]) ?? UIImage()
                self.windLabel.text = weatherModel?.windSpeed
                self.windDirection.image = UIImage(named: weatherModel!.windDirection)
            }
        }
        
    }
}


extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weatherCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell else { return UITableViewCell() }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dayWeatherCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayWeatherCell.identifier, for: indexPath) as? DayWeatherCell else { return UICollectionViewCell() }
        let cellVM = viewModel.getDayWeatherCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
    
}


extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height)

    }
}
