//
//  TableViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 27/03/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
      
  
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>! 
    private var isFiltering: Bool {
                return searchController.isActive && !searchBarIsEmpty
    }


    private var ascendingSorting = true // Свойство для сортировки

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
    
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // по умолчание searchController не позволяет никак взаимодействовать
        // с отображаемым контентом и если отключить этот параметр, то это позволит
        // взаимодействоать с этим viewController'ом также как и с основным
        // то есть мы сможем переходить по записям, удалять или смотреть детали
        

        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
 
    // MARK: - Table view data source

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredPlaces.count
        }
        return places.isEmpty ? 0 : Int(places.count)
    }
        
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:
            indexPath) as! CustomTableViewCell

        var place = Place()
        if isFiltering {place = filteredPlaces[indexPath.row]}
        else {place = places[indexPath.row]}

        cell.nameLabel?.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)

        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height/2
        cell.imageOfPlace?.clipsToBounds = true
        cell.ratingStar.rating = Int(place.rating)
        cell.ratingStar.isChanged = false
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
     
        let place = places[indexPath.row]
        
       
        let deleteAction = UITableViewRowAction(
            style: .default, // меню будет красное
            title: "Delete") // название
            { (_, _) in// логика работы
                
                StorageManager.deleteObject(place)
                tableView.deleteRows(at: [indexPath], with: .automatic)
        
            }
        
        return [deleteAction]
    }
    
    
    // метод отвечающий за высоту строки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // условие того что мы идем по правильному сигвею
        if segue.identifier == "showDetail" {
            
            // индекс строки
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
   
            
            // извлекаем данные из массива по индексу
            
            var place = Place()
            if isFiltering {place = filteredPlaces[indexPath.row]}
            else { place = places[indexPath.row] }
                
            // извлекаем направление сигвея
            let newPlaceVC = segue.destination as! NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
   
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    
    
    // Action for SegmentedControl
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
}
    
      
    @IBAction func reversedSorting(_ sender: UIBarButtonItem) {
        ascendingSorting.toggle()
        if ascendingSorting == true {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
        
    }
    

    private func sorting() {
         if segmentedControl.selectedSegmentIndex == 0 {
                    places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
                    } else { places = places.sorted(byKeyPath: "name", ascending: ascendingSorting) }
                tableView.reloadData()
        }
    }
    

// расширение с методами отвечающими за обновления таблицы
// связанным с поиском данных

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@ OR type CONTAINS[c] %@", searchText, searchText, searchText)
        tableView.reloadData()
    }
}

