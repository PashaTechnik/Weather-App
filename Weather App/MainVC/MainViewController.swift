//
//  MainViewController.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!
    
    lazy var viewModel = {
        WeatherViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
    }

    func initViewModel() {
        
        viewModel.getForecast()
        viewModel.initLocationManager()
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.weatherTableView.reloadData()
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
