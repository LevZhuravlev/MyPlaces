//
//  TableViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 27/03/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    
    // Создаем перечень заведений
    

    var places = Place.getPlaces()
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    // Этот метод возвращает количество строк для конкретной секции (обязательный)
    // каждая строка имеет свой индекс и именно по ним можно обращаться к строкам
    // соответственно для того чтобы проиндксировать все строки мы должны знать
    // общее их количество, в итоге в этом методе нам надо вернуть какое то количество строк
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(places.count)
    }
        
    // метод конфигурации ячейки (обязательный)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        // для того чтобы обратиться к числу инекса данной ячейки используется
        // метод indexPath.row, через него соответственно мы обращаемся по индексу
        // к массиву с наименованиями
        
        // создадим переменную в которую поместим
        // значение того какую ячейку мы выделели
        
        let place = places[indexPath.row]
    
        cell.nameLabel?.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        if place.image == nil {
            cell.imageOfPlace?.image = UIImage(named: place.name)
        } else {cell.imageOfPlace?.image = place.image}
        
        
        
        // сделаем изображение груглым
        // для этого радиус скругления должен быть
        // равен половине высоты изображения
        // первый метод скругляет только imageView в котором храниться
        // картинка, второй обрезает изобрадение по краям imageView
        
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height/2
        cell.imageOfPlace?.clipsToBounds = true
        return cell
    }
    
    // метод отвечающий за высоту строки
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
        
        // для начала создадим экземпляр класса NewPlaceViewController
        // (класса из которого будут приниматься данные в этот класс)
        
        guard let newPlaceVC = segue.source as? NewPlaceViewController else {return}
        
        // передача данных происходит как в обычных segue, но только в обратном
        // порядке. То есть если до этого был func prepare (for segue: ... )
        // с методом segue.destination, потому что свойство destination мы
        // используем для viewContrller'a получателя, когда мы хотим
        // передать данные от viewContrller c которого переходим viewContrller'у
        // на который мы переходим, сейчас же мы выполняем возврат с viewController'a
        // на который мы переходили ранее, данный переход делает при помощи unwind segue
        // и импользуется свойство sourse

        // теперь вызываем сам метод
        
        newPlaceVC.saveNewPlace()
        
        // добавляем в массив с элементами новый объект
        places.append(newPlaceVC.newPlace!)
        
        // и обновляем данные
        tableView.reloadData()
    }
}





