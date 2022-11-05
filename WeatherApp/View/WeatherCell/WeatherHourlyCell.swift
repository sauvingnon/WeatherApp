//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 23.10.2022.
//

import UIKit

class WeatherHourlyCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func setupCell(time: String, imageName: String, temp: Int){
        timeLabel.text = time
        imageLabel.image = UIImage(named: imageName)
        temperatureLabel.text = "\(temp) C°"
    }
}
