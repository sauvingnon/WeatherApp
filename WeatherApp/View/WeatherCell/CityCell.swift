//
//  CityCell.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 07.11.2022.
//

import UIKit

class CityCell: UITableViewCell {

    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(cityName: String){
        cityLabel.text = cityName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
