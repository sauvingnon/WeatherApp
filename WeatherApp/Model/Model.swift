//
//  Network.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 23.09.2022.
//

import Foundation

class Model{
    
    // MARK: - Properties
    // use openweathermap.org
    let apiKey = "465faf28897510725695caa4ac25f93f"
    let lang = "&lang=ru"
    let units = "&units=metric"
    let lock = NSLock()
    
    func fetchDataForCity(city: String) -> (WeatherStruct?){
        var counter = 0
        var weather: WeatherStruct?
        let finalUrlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)\(units)\(lang)"
        let url = URL(string: finalUrlString.encodeUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            do{
                if(data == nil) { return }
                let decoder = JSONDecoder()
                weather = try decoder.decode(WeatherStruct.self, from: data!)
            }
            catch {
                debugPrint(error)
            }
        }
        task.resume()
        while(weather == nil){
            if( counter > 5) { break }
            counter += 1
            Thread.sleep(forTimeInterval: 1)
        }
        return (weather)
    }
}

struct WeatherStruct: Codable {
    let coord: Coord
    struct Coord: Codable {
        let lon: Double
        let lat: Double
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
    let name: String
}
