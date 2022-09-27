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
    @IBOutlet weak var selectedButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Actions
    @IBAction func selectedButtonTapped(_ sender: Any) {
        presenter.selectedButtonTapped()
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        presenter = MainViewPresenter(view: self)
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "ок", style: .default)
        alert.addAction(yesAction)
        self.show(alert, sender: .none)
    }
    
    
    
}


extension MainView: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.showWeatherForCity(input: searchBar.text)
        view.endEditing(true)
    }
}

