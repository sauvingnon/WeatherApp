//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 23.10.2022.
//

import UIKit

class WeatherView: UIViewController {
    
    // MARK: - Properties
    var presenter: WeatherViewPresenter!
    
    // MARK: - Outlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var maxMinTemperatureLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WeatherViewPresenter(view: self)
        presenter.model = WeatherModel(presenter: presenter)
        
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        dailyCollectionView.delegate = self
        dailyCollectionView.dataSource = self
        
        presenter.getAllDataForCity(input: "Ижевск")
        // Стартовый запрос
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "ок", style: .default)
        alert.addAction(yesAction)
        self.show(alert, sender: .none)
    }
    
}

extension WeatherView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dailyCollectionView {
            return presenter.dailyWeatherCells.count
        }
        return presenter.hourlyWeatherCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == dailyCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherDailyCell", for: indexPath) as! WeatherDailyCell
            cell.setupCell(maxTemp: presenter.dailyWeatherCells[indexPath.item].tempMax, minTemp: presenter.dailyWeatherCells[indexPath.item].tempMin, imageName: presenter.dailyWeatherCells[indexPath.item].image, date: presenter.dailyWeatherCells[indexPath.item].day)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherHourlyCell", for: indexPath) as! WeatherHourlyCell
        cell.setupCell(time: presenter.hourlyWeatherCells[indexPath.item].time, imageName: presenter.hourlyWeatherCells[indexPath.item].image, temp: presenter.hourlyWeatherCells[indexPath.item].temp)
        return cell
    }
    
    
}
