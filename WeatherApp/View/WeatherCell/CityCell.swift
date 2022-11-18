//
//  CityCell.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 07.11.2022.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    var presenter: CitiesViewPresenter!
    
    @IBAction func buttonSelectedTapped(_ sender: Any) {
        presenter.selectCityTapped(cityName: cityLabel.text!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(cityName: String, isSelected: Bool, presenter: CitiesViewPresenter){
        cityLabel.text = cityName
        self.presenter = presenter
        if(isSelected){
            selectedButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            selectedButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
