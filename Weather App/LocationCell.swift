//
//  LocationCell.swift
//  Weather App
//
//  Created by Pasha on 02.11.2022.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    
    static let identifier = "locationCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
