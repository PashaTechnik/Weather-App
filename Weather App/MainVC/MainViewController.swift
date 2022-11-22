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
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel = {
        WeatherViewModel()
    }()
    
    var userCoordinates: Coord? = nil {
        didSet {
            viewModel.getForecastWithCoord(coord: userCoordinates)
        }
    }
    
    var city: String? = nil {
        didSet {
            viewModel.getForecastWithCity(city: city!)
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
            weatherIcon.isHidden = true
        } else {
            weatherIcon.isHidden = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        darkView.isHidden = false
    }

    func initViewModel() {
        
        viewModel.getForecastWithCoord(coord: userCoordinates)
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
        
        viewModel.weatherModel.bind { [weak self] weatherModel in
            guard let self = self else { return }
            guard let weatherModel = weatherModel else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.darkView.isHidden = true
                self.dateLabel.text = weatherModel.date
                self.cityNameLabel.text = weatherModel.city
                self.humidityValueLabel.text = weatherModel.humidity
                self.temperatureValueLabel.text = "\(String(Int(weatherModel.minTemperature)))° / \(String(Int(weatherModel.maxTemperature)))°"
                self.weatherIcon.image = UIImage(named: Utilities.iconDict[weatherModel.icon, default: "ic_white_day_bright"]) ?? UIImage()
                self.windLabel.text = weatherModel.windSpeed
                self.windDirection.image = UIImage(named: weatherModel.windDirection)
            }
        }
        
    }
    @IBAction func goToSearch(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SearchVC") as! SearchViewController
        navigationController?.pushViewController(vc, animated: true)
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
