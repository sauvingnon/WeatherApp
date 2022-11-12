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
    weak var view: WeatherView!
    var model: WeatherModel!
    
    init(view: WeatherView){
        self.view = view
    }
    
    func getAllDataForCity(input: String?){
        // Метод для запроса всех данных о температуре в городе - почасовой прогноз и текущую погоду
        if(input == nil || requestIsBeasy) { return }
        if(input!.isEmpty) { return }
        if CheckInternetConnection.currentReachabilityStatus() == .notReachable {
            view.showAlert(title: "Ошибка!", message: "Отсутствует подключение к интернету!")
            debugPrint("Нет подключения к сети интернет!")
            return
        }
        view.activityIndicator.startAnimating()
        requestIsBeasy = true
        let text = input?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        //view.searchBar.text = text
        let queue = DispatchQueue(label: "networkRequest")
        queue.async {
            self.model.fetchHourlyDataForCity(city: text!)
            self.model.fetchCurrentDataForCity(city: text!)
            Thread.sleep(forTimeInterval: 5)
            if self.requestIsBeasy {
                self.view.showAlert(title: "Ошибка!", message: "Что-то пошло не так..")
                self.requestIsBeasy = false
            }
        }
    }
    
    func UpdateHourlyWeather(){
        if(hourlyWeathers == nil) {
            debugPrint("hourly weather is nil!")
            return
        }
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
                debugPrint("current weather is nil!")
            }else{
                var visability = String(currentWeather!.visibility / 1000)
                if visability == "10" {
                    visability = "более \(visability)"
                }
                view.visabilityLabel.text = "\(visability) км"
                view.windSpeedLabel.text = "\(currentWeather!.wind.speed) м/с"
                let pressure = Double(currentWeather!.main.pressure) / 1.333
                view.pressureLabel.text = "\(Int(pressure)) мм рт. ст."
                view.humidityLabel.text = "\(currentWeather!.main.humidity) %"
                view.cloudyLabel.text = "\(currentWeather!.clouds.all) %"
                view.temperatureLabel.text = "\(currentWeather!.main.temp)°"
                view.cityLabel.text = currentWeather!.name
                view.descriptionLabel.text = currentWeather!.weather.first?.description
                view.maxMinTemperatureLabel.text = "макс: \(currentWeather!.main.temp_max)°, " + "мин: \(currentWeather!.main.temp_min)°"
                let sunsetTime = unixTimeConvertion(unixTime: currentWeather!.sys.sunset)
                view.sunsetLabel.text = sunsetTime
                let sunriseTime = unixTimeConvertion(unixTime: currentWeather!.sys.sunrise)
                view.sunriseLabel.text = sunriseTime
            }
            requestIsBeasy = false
            view.activityIndicator.stopAnimating()
        }
    }
    
    func UpdateDailyWeather(){
        if(hourlyWeathers == nil) { return }
        dailyWeatherCells.removeAll()
        var oldWeatherIndex: Int
        for item in (hourlyWeathers?.list)!{
            let dayOfWeek = getDayOfWeek(fullStringDay: item.dt_txt)
            if dailyWeatherCells.contains(where: { element in
                if element.day == dayOfWeek{
                    return true
                }
                return false
            })
            {
                // Если такой день уже есть - обновим максимумы и минимумы
                oldWeatherIndex = dailyWeatherCells.firstIndex(where: { element in
                    if element.day == dayOfWeek {
                        return true
                    }
                    return false
                })!
                dailyWeatherCells[oldWeatherIndex].tempMax = max(dailyWeatherCells[oldWeatherIndex].tempMax, Int(item.main.temp_max))
                dailyWeatherCells[oldWeatherIndex].tempMin = min(dailyWeatherCells[oldWeatherIndex].tempMin, Int(item.main.temp_min))
            }
            else{
                // Такого дня недели не существует - добавим его
                let newWeather = WeatherDailyCellStruct(tempMax: Int(item.main.temp_max), tempMin: Int(item.main.temp_min), image: item.weather.first!.icon, day: dayOfWeek)
                dailyWeatherCells.append(newWeather)
            }
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
//        let onlyDate = fullStringDay.components(separatedBy: " ").first!
        let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        if let todayDate = formatter.date(from: fullStringDay){
            let numberOfWeekDay = Calendar.current.dateComponents([.weekday], from: todayDate).weekday!
            return weekdays[numberOfWeekDay]
            } else {
                return "bad data"
            }
    }
    
    func unixTimeConvertion(unixTime: Int) -> String {
        let time = NSDate(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = NSTimeZone(name: timeZoneInfo)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.system.identifier) as Locale?
        dateFormatter.dateFormat = "hh:mm a"
        let dateAsString = dateFormatter.string(from: time as Date)
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from: date!)
        return date24
    }
    
}
