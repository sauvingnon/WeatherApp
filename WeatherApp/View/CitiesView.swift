//
//  CitiesView.swift
//  WeatherApp
//
//  Created by Гриша Шкробов on 07.11.2022.
//

import UIKit

class CitiesView: UIViewController {
    
    var presenter: CitiesViewPresenter!
    
    var weatherView: WeatherView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var citiesTableView: UITableView!
    
    @IBAction func buttonEditTapped(_ sender: Any) {
        citiesTableView.setEditing(!citiesTableView.isEditing, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = CitiesViewPresenter(view: self)
        
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
        searchBar.delegate = self
        
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(CitiesView.actionRightSwipeGesture(_:)))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func actionRightSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }
    
}

extension CitiesView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarButtonTapped(input: searchBar.text!)
        view.endEditing(true)
    }
    
}

extension CitiesView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.arrayOfCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        cell.setupCell(cityName: presenter.arrayOfCities[indexPath.item])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.arrayOfCities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("You tapped cell number \(indexPath.row).")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notesText = presenter.arrayOfCities[indexPath.row]
        
        dismiss(animated: true)
        
        weatherView.presenter.getAllDataForCity(input: notesText)
        
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
    }
    
}
