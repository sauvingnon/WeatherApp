//
//  ViewController.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 21.09.2022.
//

import UIKit

class MainView: UIViewController {
    
    // MARK: - Properties
    private var presenter: MainViewPresenter!
    
    // MARK: Outlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainViewPresenter(view: self)
        searchBarOptions()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Methods
    func searchBarOptions(){
        searchBar.delegate = self
        searchBar.placeholder = "Введите город"
    }
    
}

extension MainView: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarInput(text: searchBar.text)
    }
    
}

