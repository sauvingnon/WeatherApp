//
//  WeatherDailyCell.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 01.11.2022.
//

import UIKit

class WeatherDailyCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    func setupCell(maxTemp: Int, minTemp: Int, imageName: String, date: String){
        tempLabel.text = "max \(maxTemp) C° min \(minTemp) C°"
        dateLabel.text = date
    }
}
