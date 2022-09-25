//
//  Network.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 21.09.2022.
//

import Foundation

class MainViewPresenter{
    
    // MARK: Properties
    var weather: WeatherStruct?
    
    unowned var view: MainView
    var model: Model
    
    // MARK: - Initializers
    init(view: MainView) {
        self.view = view
        model = Model()
    }
    
    func searchBarInput(text: String?){
        if(text == nil) { return }
        let queue = DispatchQueue(label: "networkRequest")
        queue.async { [self] in
            weather = model.fetchDataForCity(city: text!)
            if(weather == nil){
                debugPrint("weather is nil!")
                // Alert Controller need
                return
            }
            DispatchQueue.main.async { [self] in
                view.humidityLabel.text = String((weather?.main.humidity)!)
                view.temperatureLabel.text = String((weather?.main.temp)!)
                view.cityLabel.text = weather?.name
            }
        }
    
    }
    
    
}
