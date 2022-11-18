//
//  CitiesViewPresenter.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 07.11.2022.
//

import Foundation

class CitiesViewPresenter{
    
    var arrayOfCities: [String]{
        get{
            return UserDefaults.standard.array(forKey: "UserCities") as? [String] ?? [String]()
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "UserCities")
        }
    }
    var view: CitiesView
    
    var selectedCity: String{
        get{
            return UserDefaults.standard.string(forKey: "SelectedCity") ?? "Москва"
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "SelectedCity")
        }
    }
    
    init(view: CitiesView){
        self.view = view
    }
    
    func searchBarButtonTapped(input: String){
        if(input.isEmpty) { return }
        arrayOfCities.append(input)
        view.searchBar.text = ""
        view.citiesTableView.reloadData()
    }
    
    func selectCityTapped(cityName: String){
        selectedCity = cityName
        view.citiesTableView.reloadData()
    }
    
}
