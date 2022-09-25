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
    
    func fetchDataForCity(city: String) -> (city: String?, temp: Double?, humid: Int?){
        var locationName: String?
        var temperature: Double?
        var humidity: Int?
        
        let finalUrlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)\(units)\(lang)"
        let url = URL(string: finalUrlString)
        if (url == nil){
            debugPrint("url is nil!")
            return (nil, nil, nil)
        }
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            do{
                let json = try JSONSerialization.jsonObject(with: data!)
                as! [String: AnyObject]
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(WeatherStruct.self, from: data!)
                
                locationName = json["name"] as? String
                
                /*
                if let weather = json["weather"] {
                    if let abc = weather[0] {
                        if let dfdg = abc[3]{
                            let descriprionWeather = dfdg["description"] as? String
                        }
                    }
                }
                */
    
                if let main = json["main"] {
                    temperature = main["temp"] as? Double
                    let temperatureFeelsLike = main["feels_like"] as? Double
                    let temperatureMax = main["temp_max"] as? Double
                    let temperatureMin = main["temp_min"] as? Double
                    humidity = main["humidity"] as? Int
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
        while(true){
            if(humidity != nil) {
                break
            }
        }
     
        return (locationName, temperature, humidity)
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
        let sea_level: Int
        let grnd_level: Int
    }
    let visibility: Int
    let wind: Wind
    struct Wind: Codable{
        let speed: Double
        let deg: Int
        let gust: Double
    }
    let name: String
}
