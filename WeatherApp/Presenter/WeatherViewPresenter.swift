//
//  WeatherViewPresenter.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 23.10.2022.
//

import Foundation

class WeatherViewPresenter{
    
    var currentWeather: CurrentWeatherStruct?
    var hourlyWeathers: HourlyWeatherStruct?
    var hourlyWeatherCells = [WeatherHourlyCellStruct]()
    var dailyWeatherCells = [WeatherDailyCellStruct]()
    var requestIsBeasy = false
    var view: WeatherView
    var model: WeatherModel!
    
    init(view: WeatherView){
        self.view = view
    }
    
    func getAllDataForCity(input: String?){
        // Метод для запроса всех данных о температуре в городе - почасовой прогноз и текущую погоду
        if(input == nil || requestIsBeasy) { return }
        if(input!.isEmpty) { return }
        //view.activityIndicator.startAnimating()
        requestIsBeasy = true
        let text = input?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        //view.searchBar.text = text
        let queue = DispatchQueue(label: "networkRequest")
        queue.async {
            self.model.fetchHourlyDataForCity(city: text!)
            self.model.fetchCurrentDataForCity(city: text!)
        }
    }
    
    func UpdateHourlyWeather(){
        if(hourlyWeathers == nil) { return }
        hourlyWeatherCells.removeAll()
        for item in (hourlyWeathers?.list)!{
            let temp = Int(item.main.temp)
            let time = (item.dt_txt.components(separatedBy: " ").last?.components(separatedBy: ":").first)! + ":00"
            hourlyWeatherCells.append(WeatherHourlyCellStruct(temp: temp, image: item.weather.first!.icon, time: time))
        }
        DispatchQueue.main.async {
            self.view.hourlyCollectionView.reloadData()
        }
    }
    
    func UpdateCurrentWeather(){
        DispatchQueue.main.async { [self] in
            if(currentWeather == nil){
                debugPrint("weather is nil!")
                view.showAlert(title: "Ошибка!", message: "Что-то пошло не так..")
            }else{
                view.temperatureLabel.text = "\(currentWeather!.main.temp) C°"
                view.cityLabel.text = currentWeather?.name
                view.descriptionLabel.text = currentWeather?.weather.first?.description
                view.maxMinTemperatureLabel.text = "макс: \(currentWeather!.main.temp_max) C°, " + "мин: \(currentWeather!.main.temp_min) C°"
            }
            requestIsBeasy = false
//            view.activityIndicator.stopAnimating()
        }
    }
    
    func UpdateDailyWeather(){
        if(hourlyWeathers == nil) { return }
        dailyWeatherCells.removeAll()
        var dictHourlyWeathers = [String: WeatherDailyCellStruct]()
        var oldWeather: WeatherDailyCellStruct
        for item in (hourlyWeathers?.list)!{
            let dayOfWeek = getDayOfWeek(fullStringDay: item.dt_txt)
            if dictHourlyWeathers.keys.contains(where: { String in
                if String == dayOfWeek{
                    return true
                }
                return false
            })
            {
                // Если такой день уже есть - обновим максимумы и минимумы
                oldWeather = dictHourlyWeathers[dayOfWeek]!
                oldWeather.tempMax = max(oldWeather.tempMax, Int(item.main.temp_max))
                oldWeather.tempMin = min(oldWeather.tempMin, Int(item.main.temp_min))
                dictHourlyWeathers.updateValue(oldWeather, forKey: dayOfWeek)
            }
            else{
                // Такого дня недели не существует - добавим его
                var newWeather = WeatherDailyCellStruct(tempMax: Int(item.main.temp_max), tempMin: Int(item.main.temp_min), image: item.weather.first!.icon, day: dayOfWeek)
                dictHourlyWeathers.updateValue(newWeather, forKey: dayOfWeek)
            }
        }
        dictHourlyWeathers.forEach { (key: String, value: WeatherDailyCellStruct) in
            dailyWeatherCells.append(WeatherDailyCellStruct(tempMax: value.tempMax, tempMin: value.tempMin, image: value.image, day: key))
        }
        DispatchQueue.main.async {
            self.view.dailyCollectionView.reloadData()
        }
    }
    
    // MARK: - Methods
    private func getDayOfWeek(fullStringDay: String) -> (String){
        let weekdays = [
                    "bad data",
                    "Воскресенье",
                    "Понедельник",
                    "Вторник",
                    "Среда",
                    "Четверг",
                    "Пятница",
                    "Суббота"
                ]
        let onlyDate = fullStringDay.components(separatedBy: " ").first!
        let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        if let todayDate = formatter.date(from: fullStringDay){
            let numberOfWeekDay = Calendar.current.dateComponents([.weekday], from: todayDate).weekday!
            return weekdays[numberOfWeekDay]
            } else {
                return "bad data"
            }
    }
    
}
