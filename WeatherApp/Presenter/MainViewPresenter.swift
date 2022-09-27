//
//  Network.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 21.09.2022.
//

import Foundation
import UIKit
import AudioToolbox

class MainViewPresenter{
    
    // MARK: Properties
    var weather: WeatherStruct?
    var selectedCity: String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "SelectedCity")
            UserDefaults.standard.synchronize()
            syncronizeSelectedCity()
        }
        get{
            if let city = UserDefaults.standard.string(forKey: "SelectedCity")
                as String? {
                return city
            } else {
                return nil
            }
        }
    }
    unowned var view: MainView
    var model: Model
    var weatherIsBeasy: Bool
    
    // MARK: - Initializers
    init(view: MainView) {
        self.view = view
        model = Model()
        weatherIsBeasy = false
        syncronizeSelectedCity()
    }
    
    func syncronizeSelectedCity(){
        if(selectedCity != nil){
            showWeatherForCity(input: selectedCity)
        }
    }
    
    func showWeatherForCity(input: String?){
        if(input == nil || weatherIsBeasy) { return }
        if(input!.isEmpty) { return }
        view.activityIndicator.startAnimating()
        weatherIsBeasy = true
        let text = input?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        view.searchBar.text = text
        if(text == selectedCity){
            changeStateSelectedButton(state: .fill)
        }else{
            changeStateSelectedButton(state: .empty)
        }
        let queue = DispatchQueue(label: "networkRequest")
        queue.async { [self] in
            weather = model.fetchDataForCity(city: text!)
            DispatchQueue.main.async { [self] in
                if(weather == nil){
                    debugPrint("weather is nil!")
                    view.activityIndicator.stopAnimating()
                    view.searchBar.text = ""
                    view.showAlert(title: "Ошибка!", message: "Что-то пошло не так..")
                }else{
                    view.humidityLabel.text = String(weather?.main.humidity ?? 0) + " %"
                    view.temperatureLabel.text = String(weather?.main.temp ?? 0) + " C°"
                    view.pressureLabel.text = String(weather?.main.pressure ?? 0) + " hPa"
                    view.windSpeedLabel.text = String(weather?.wind.speed ?? 0) + " mps"
                    view.cityLabel.text = weather?.name
                    view.descriptionLabel.text = weather?.weather.first?.description
                    view.activityIndicator.stopAnimating()
                }
            }
            weatherIsBeasy = false
        }
    
    }
    
    func selectedButtonTapped(){
        UINotificationFeedbackGenerator().notificationOccurred(.success) // вибрация
        if(!view.searchBar.text!.isEmpty){
            selectedCity = view.searchBar.text?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            changeStateSelectedButton(state: .fill)
            view.showAlert(title: "Успешно!", message: "\(selectedCity!) теперь ваш избранный город!")
        }
    }
    
    func changeStateSelectedButton(state: State){
        if(state == .fill){
            view.selectedButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else{
            view.selectedButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
}

enum State{
    case fill
    case empty
}
