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
    
    init(view: CitiesView){
        self.view = view
    }
    
    func searchBarButtonTapped(input: String){
        if(input.isEmpty) { return }
        arrayOfCities.append(input)
        view.searchBar.text = ""
        view.citiesTableView.reloadData()
    }
    
}
