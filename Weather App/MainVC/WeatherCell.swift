//
//  WeatherCell.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    static let identifier = "weatherCell"
    
    var cellViewModel: WeatherCellViewModel? {
        didSet {
            dayLabel.text = cellViewModel?.day
            temperatureLabel.text = cellViewModel?.temperature
            weatherImage.image = cellViewModel?.forecastIcon
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            
            weatherImage.tintColor = UIColor(named: "CustomBlueLight")!
            dayLabel.textColor = UIColor(named: "CustomBlueLight")!
            temperatureLabel.textColor = UIColor(named: "CustomBlueLight")!
            
            clipsToBounds = false
            layer.shadowColor = UIColor(named: "CustomBlueLight")!.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowOffset = .zero
            layer.shadowRadius = 15
        } else {
            weatherImage.tintColor = .black
            dayLabel.textColor = .black
            temperatureLabel.textColor = .black
            layer.shadowColor = UIColor.clear.cgColor

        }
        
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        temperatureLabel.text = nil
        weatherImage.image = nil
    }
}
