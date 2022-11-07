//
//  SearchViewController.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private let placesClient = GMSPlacesClient()
    
    private var placesResult: [GMSAutocompletePrediction] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        tableView.delegate = self
        tableView.dataSource = self
        
        textField.addTarget(nil, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @IBAction func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange() {
        let token = GMSAutocompleteSessionToken.init()
        
        let filter = GMSAutocompleteFilter()
        
        filter.types = ["locality"]
        placesClient.findAutocompletePredictions(fromQuery: textField.text!, filter: filter,
            sessionToken: token,
            callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            if let results = results {
                self.placesResult = []
                for result in results {
                    self.placesResult.append(result)
                }
            }
        })

    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier) as! LocationCell
        cell.locationLabel.text = placesResult[indexPath.row].attributedFullText.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = placesResult[indexPath.row].attributedPrimaryText.string
        navigationController?.popViewController(animated: true)
        let vc = navigationController?.topViewController as! MainViewController
        vc.city = cityName
    }
    
    
}
