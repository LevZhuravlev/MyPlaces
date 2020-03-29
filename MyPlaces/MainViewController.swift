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
    
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    // Этот метод возвращает количество строк для конкретной секции (обязательный)
    // каждая строка имеет свой индекс и именно по ним можно обращаться к строкам
    // соответственно для того чтобы проиндксировать все строки мы должны знать
    // общее их количество, в итоге в этом методе нам надо вернуть какое то количество строк
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(restaurantNames.count)
    }

    
    // метод конфигурации ячейки (обязательный)
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // для того чтобы обратиться к числу инекса данной ячейки используется
        // метод indexPath.row, через него соответственно мы обращаемся по индексу
        // к массиву с наименованиями
        cell.textLabel?.text = restaurantNames[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurantNames[indexPath.row]) 
        
        // сделаем изображение груглым
        // для этого радиус скругления должен быть
        // равен половине высоты строки
        // первый метод скругляет только imageView в котором храниться
        // картинка, второй обрезает изобрадение по краям imageView
        cell.imageView?.layer.cornerRadius = cell.frame.height/2
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    // метод отвечающий за высоту строки
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    

}
