//
//  Network.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 21.09.2022.
//

import Foundation

class MainViewPresenter{
    
    // MARK: Properties
    var locationName: String?
    //var descriprionWeather: String?
    var temperature: Double?
    var temperatureFeelsLike: Double?
    var temperatureMax: Double?
    var temperatureMin: Double?
    var humidity: Int?
    
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
            let result = model.fetchDataForCity(city: text!)
            locationName = result.city
            temperature = result.temp
            humidity = result.humid
            if(humidity == nil || temperature == nil || locationName == nil){
                debugPrint("temp or humid is nil!")
                // Alert Controller
                return
            }
            view.printInfo(city: locationName!, temperature: temperature!, humidity: humidity!)
        }
    }
    
    
}
