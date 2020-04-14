//
//  TableViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 27/03/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    
    // Создаем перечень заведений
    
    var places: Results<Place>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
         
    }

    // MARK: - Table view data source

    // Количество строк
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : Int(places.count)
    }
        
    
    // метод конфигурации ячейки (обязательный)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        
        // для начала создадим экземпляр класса NewPlaceViewController
        // (класса из которого будут приниматься данные в этот класс)
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        newPlaceVC.saveNewPlace()
        
        // добавляем в массив с элементами новый объект
        // и обновляем данные
        tableView.reloadData()
    }
}

