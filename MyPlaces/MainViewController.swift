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
    

    let places = Place.getPlaces()
    

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
        
        cell.nameLabel?.text = places[indexPath.row].name
        cell.imageOfPlace?.image = UIImage(named: places[indexPath.row].name)
        cell.locationLabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        
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
    
    @IBAction func cancelActoin(_ segue: UIStoryboardSegue){}

}
