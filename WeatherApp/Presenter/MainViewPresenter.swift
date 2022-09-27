//
//  Network.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 21.09.2022.
//

import Foundation
import UIKit

class MainViewPresenter{
    
    // MARK: Properties
    var weather: WeatherStruct?
    unowned var view: MainView
    var model: Model
    var weatherIsBeasy: Bool
    
    // MARK: - Initializers
    init(view: MainView) {
        self.view = view
        model = Model()
        weatherIsBeasy = false
    }
    
    func searchBarInput(input: String?){
        if(input == nil || weatherIsBeasy) { return }
        if(input!.isEmpty) { return }
        view.activityIndicator.startAnimating()
        weatherIsBeasy = true
        let text = input?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        view.searchBar.text = text
        let queue = DispatchQueue(label: "networkRequest")
        queue.async { [self] in
            weather = model.fetchDataForCity(city: text!)
            DispatchQueue.main.async { [self] in
                if(weather == nil){
                    debugPrint("weather is nil!")
                    view.activityIndicator.stopAnimating()
                    view.searchBar.text = ""
                    let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так!", preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "ок", style: .default)
                    alert.addAction(yesAction)
                    view.show(alert, sender: .none)
                }else{
                    view.humidityLabel.text = String((weather?.main.humidity)!) + " %"
                    view.temperatureLabel.text = String((weather?.main.temp)!) + " C"
                    view.cityLabel.text = weather?.name
                    view.descriptionLabel.text = weather?.weather.first?.description
                    view.activityIndicator.stopAnimating()
                }
            }
            weatherIsBeasy = false
        }
    
    }
    
    
}
