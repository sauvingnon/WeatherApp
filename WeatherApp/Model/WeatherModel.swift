//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 24.10.2022.
//

import Foundation
import UIKit

class WeatherModel{
    
    let apiKey = "465faf28897510725695caa4ac25f93f"
    let lang = "&lang=ru"
    let units = "&units=metric"
    
    weak var presenter: WeatherViewPresenter!
    
    init(presenter: WeatherViewPresenter){
        self.presenter = presenter
    }
    
    func fetchHourlyDataForCity(city: String){
        // Метод для запроса данных о почасовом прогнозе погоды
        var weather: HourlyWeatherStruct?
        
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)\(lang)\(units)"
        let url = URL(string: urlString.encodeUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            do{
                if(data != nil){
                    let decoder = JSONDecoder()
                    weather = try decoder.decode(HourlyWeatherStruct.self, from: data!)
                    self.presenter.hourlyWeathers = weather
                    self.presenter.UpdateHourlyWeather()
                    self.presenter.UpdateDailyWeather()
                }
            }
            catch {
                debugPrint(error)
            }
            
        }
        task.resume()
    }
    
    func fetchCurrentDataForCity(city: String){
        var weather: CurrentWeatherStruct?
        let finalUrlString = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)\(units)\(lang)"
        let url = URL(string: finalUrlString.encodeUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            do{
                if(data != nil){
                    let decoder = JSONDecoder()
                    weather = try decoder.decode(CurrentWeatherStruct.self, from: data!)
                    self.presenter.currentWeather = weather
                    self.presenter.UpdateCurrentWeather()
                }
            }
            catch {
                debugPrint(error)
            }
        }
        task.resume()
    }
    
}

struct WeatherHourlyCellStruct{
    var temp: Int
    var image: String
    var time: String
}

struct WeatherDailyCellStruct{
    var tempMax: Int
    var tempMin: Int
    var image: String
    var day: String
}

struct HourlyWeatherStruct: Codable {
    let cod: String
    let cnt: Int
    var list: [List]
    struct List: Codable{
        var main: Main
        struct Main: Codable{
            let temp: Double
            let feels_like: Double
            let temp_min: Double
            let temp_max: Double
            let pressure: Int
            let humidity: Int
            let sea_level: Int?
            let grnd_level: Int?
        }
        var weather: [Weather]
        struct Weather: Codable{
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
        var wind: Wind
        struct Wind: Codable{
            let speed: Double
            let deg: Int
            let gust: Double?
        }
        var dt_txt: String
    }
    
    let city: City
    struct City: Codable{
        let name: String
        let coord: Coord
        struct Coord: Codable {
            let lon: Double
            let lat: Double
        }
    }
}

struct CurrentWeatherStruct: Codable {
    let coord: Coord
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
    let sys: Sys
    struct Sys: Codable{
        let sunrise: Int
        let sunset: Int
    }
    let weather: [Weather]
    struct Weather: Codable{
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    let base: String
    let main: Main
    struct Main: Codable{
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
        let sea_level: Int?
        let grnd_level: Int?
    }
    let visibility: Int
    let wind: Wind
    struct Wind: Codable{
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    let clouds: Clouds
    struct Clouds: Codable{
        let all: Int
    }
    let name: String
}
