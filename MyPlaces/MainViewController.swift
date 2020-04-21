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
      // передавая в контроллер nil мы сообщаем ему что, мы хотим
      // использовать для вывода результата тот же контроллер
  
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var places: Results<Place>! // Создаем перечень заведений
    private var filteredPlaces: Results<Place>! // Создаем коллекцию для отфильтрованных заведений
    private var ascendingSorting = true // Свойство для сортировки
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        // setup SearchController
        
        // Свойство searchResultsUpdater (подписанное под UISearchResultsUpdating)
        // Присваивая ему значение self, мы тем самым говорим, что получателем информации
        // об изменении текста в поисковой строке должен быть наш класс
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // по умолчание searchController не позволяет никак взаимодействовать
        // с отображаемым контентом и если отключить этот параметр, то это позволит
        // взаимодействоать с этим viewController'ом также как и с основным
        // то есть мы сможем переходить по записям, удалять или смотреть детали
        
        // далее присвоим название для нашей строки поиска
        searchController.searchBar.placeholder = "search"
        
        // далее присвоим строку поиска объекту navigationItem
        navigationItem.searchController = searchController
        
        
        // то есть строка поиска у нас будет
        // интергрированна в navigationBar
        
        // данное свойство позволяет отпустить строку поиска
        // при переходе на другой экран
        definesPresentationContext = true
        
    }
 
    // MARK: - Table view data source

    // Количество строк
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : Int(places.count)
    }
        
    
    // метод конфигурации ячейки (обязательный)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:
            indexPath) as! CustomTableViewCell

        let place = places[indexPath.row]

        cell.nameLabel?.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)

        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height/2
        cell.imageOfPlace?.clipsToBounds = true
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // данный метод является методом суперкласса
        
        // в теле метода определяем объект для удаления
        // объект берем из массива places по индексу текущей строки
        let place = places[indexPath.row]
        
        // теперь нам надо определить действие при свайпе
        let deleteAction = UITableViewRowAction(
            style: .default, // меню будет красное
            title: "Delete") // название
            { (_, _) in// логика работы
                
                // вызываем метод удаления объекта из базы
                StorageManager.deleteObject(place)
                
                // вызываем метод удаления строки
                tableView.deleteRows(at: [indexPath], with: .automatic)
        
            }
        
        // возвращаем как элемент массива
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
            let place = places[indexPath.row]
                
            // извлекаем направление сигвея
            let newPlaceVC = segue.destination as! NewPlaceViewController
            
            // и добираемся в классе NewPlaceViewController
            // до свойства currentPlace
            
            newPlaceVC.currentPlace = place
            // тем самым мы передали объект с типом Place из выбранной ячейки
            // на NewPlaceViewController
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        
        // для начала создадим экземпляр класса NewPlaceViewController
        // (класса из которого будут приниматься данные в этот класс)
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        newPlaceVC.savePlace()
        
        // добавляем в массив с элементами новый объект
        // и обновляем данные
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
        } else { reversedSortingButton.image = #imageLiteral(resourceName: "ZA") }
        
        sorting()
        
    }
    
    // далее прописываем логику ту же что и при выборе того или иного сегмента
    // и чтобы не повторятся мы объявим отдельный приватный метод для сортировки
    
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
    
    // метод отвечающий за поиск контента
    // в качестве параметра принимает текст
    // из строки поиска
    private func filterContentForSearchText(_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR locations CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
        
    }
}

