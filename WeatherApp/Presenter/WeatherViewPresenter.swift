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
    var requestIsBusy = false
    weak var view: WeatherView!
    var model: WeatherModel!
    
    var selectedCity: String{
        get{
            return UserDefaults.standard.string(forKey: "SelectedCity") ?? "Москва"
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "SelectedCity")
        }
    }
    
    init(view: WeatherView){
        self.view = view
    }
    
    func getAllDataForCity(input: String?){
        // Метод для запроса всех данных о температуре в городе - почасовой прогноз и текущую погоду
        if(input == nil || requestIsBusy) { return }
        if(input!.isEmpty) { return }
        if CheckInternetConnection.currentReachabilityStatus() == .notReachable {
            view.showAlert(title: "Ошибка!", message: "Отсутствует подключение к интернету!")
            debugPrint("Нет подключения к сети интернет!")
            return
        }
        view.activityIndicator.startAnimating()
        requestIsBusy = true
        let text = input?.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        //view.searchBar.text = text
        let queue = DispatchQueue(label: "networkRequest")
        queue.async {
            self.model.fetchHourlyDataForCity(city: text!)
            self.model.fetchCurrentDataForCity(city: text!)
            Thread.sleep(forTimeInterval: 5)
            if self.requestIsBusy {
                self.view.showAlert(title: "Ошибка!", message: "Что-то пошло не так..")
                self.requestIsBusy = false
            }
        }
    }
    
    func UpdateHourlyWeather(){
        // Метод для отображения на экране свежих данных о погоде(почасовой)
        if(hourlyWeathers == nil) {
            debugPrint("hourly weather is nil!")
            return
        }
        hourlyWeatherCells.removeAll()
        for item in (hourlyWeathers?.list)!{
            let temp = Int(item.main.temp ?? 0)
            let time = (item.dt_txt.components(separatedBy: " ").last?.components(separatedBy: ":").first)! + ":00"
            hourlyWeatherCells.append(WeatherHourlyCellStruct(temp: temp, image: item.weather.first!.icon, time: time))
        }
        DispatchQueue.main.async {
            self.view.hourlyCollectionView.reloadData()
        }
    }
    
    func UpdateCurrentWeather(){
        // Метод для отображения на экране свежих данных о погоде(текущей)
        DispatchQueue.main.async { [self] in
            if(currentWeather == nil){
                debugPrint("current weather is nil!")
            }else{
                var visability = String((currentWeather!.visibility ?? 0) / 1000)
                if visability == "10" {
                    visability = "более \(visability)"
                }
                view.visabilityLabel.text = "\(visability) км"
                view.windSpeedLabel.text = "\(currentWeather!.wind.speed ?? 0) м/с"
                let pressure = Double(currentWeather!.main.pressure ?? 0) / 1.333
                view.pressureLabel.text = "\(Int(pressure)) мм рт. ст."
                view.humidityLabel.text = "\(currentWeather!.main.humidity ?? 0) %"
                view.cloudyLabel.text = "\(currentWeather!.clouds.all ?? 0) %"
                view.temperatureLabel.text = "\(currentWeather!.main.temp ?? 0)°"
                view.cityLabel.text = currentWeather!.name
                view.descriptionLabel.text = currentWeather!.weather.first?.description
                view.maxMinTemperatureLabel.text = "макс: \(currentWeather!.main.temp_max ?? 0)°, " + "мин: \(currentWeather!.main.temp_min ?? 0)°"
                let sunsetTime = unixTimeConvertion(unixTime: currentWeather!.sys.sunset ?? 0)
                view.sunsetLabel.text = sunsetTime
                let sunriseTime = unixTimeConvertion(unixTime: currentWeather!.sys.sunrise ?? 0)
                view.sunriseLabel.text = sunriseTime
                view.windGustLabel.text = "\(currentWeather!.wind.gust!) м/с"
                view.windDirectionLabel.text = getDirectionWindFromDegree(degree: currentWeather!.wind.deg ?? 0)
            }
            requestIsBusy = false
            view.activityIndicator.stopAnimating()
        }
    }
    
    func UpdateDailyWeather(){
        // Метод для отображения на экране свежих данных о погоде(недельной)
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
                dailyWeatherCells[oldWeatherIndex].tempMax = max(dailyWeatherCells[oldWeatherIndex].tempMax, Int(item.main.temp_max ?? 0))
                dailyWeatherCells[oldWeatherIndex].tempMin = min(dailyWeatherCells[oldWeatherIndex].tempMin, Int(item.main.temp_min ?? 0))
            }
            else{
                // Такого дня недели не существует - добавим его
                let newWeather = WeatherDailyCellStruct(tempMax: Int(item.main.temp_max ?? 0), tempMin: Int(item.main.temp_min ?? 0), image: item.weather.first!.icon, day: dayOfWeek)
                dailyWeatherCells.append(newWeather)
            }
        }
        DispatchQueue.main.async {
            self.view.dailyCollectionView.reloadData()
        }
    }
    
    // MARK: - Methods
    private func getDirectionWindFromDegree(degree: Int)->String{
        // Метод, преобразующий градус направления ветра в его конкретное название
        if(degree <= 22 || degree >= 337){
            return "Север"
        }
        if(degree >= 22 && degree < 67){
            return "СВ"
        }
        if(degree >= 67 && degree < 112){
            return "Восток"
        }
        if(degree >= 112 && degree < 157){
            return "ЮВ"
        }
        if(degree >= 157 && degree < 202){
            return "Юг"
        }
        if(degree >= 202 && degree < 247){
            return "ЮЗ"
        }
        if(degree >= 247 && degree < 292){
            return "Запад"
        }
        if(degree >= 292 && degree < 337){
            return "СЗ"
        }
        return "--"
    }
    
    private func getDayOfWeek(fullStringDay: String) -> (String){
        // Метод, преобразующий набор цифр с сервера в названия дней недели
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
        // Метод, преобразующий unix-время в нормализованное
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
