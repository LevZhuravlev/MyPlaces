    //
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 04/04/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // тут мы проверяем на какую ячейку было нажатие
        if indexPath.row == 0 {
            
            // тут будет логика
            // вызова меню для картинки
            
        }
            
        else {
            // а тут мы будем просто
            // скрывать при тапе на другие ячейки
            view.endEditing(true)}
    }
    
    
    }

    
// MARK: Text field delegate
    
// Для того чтобы поработать с клавиатурой
// нам необходимо подписаться под протокол UITextFieldDelegate

    extension NewPlaceViewController: UITextFieldDelegate {
        
        // скрываем клавиаутуру по нажатию на done
        // и делать мы это будем в методе
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        
        
    }
