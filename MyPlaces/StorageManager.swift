//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 11/04/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import RealmSwift

// для работы с базой нам нужно создать
// объект Realm, который будет представлять
// доступ к базе данных, и данный объект должен быть
// добавлен как глобальная переменная, поэтому создаем
// его до того как создадим новый класс

let realm = try! Realm()


class StorageManager {
    

    // далее в нашем классе реализуем метод для сохранения объектов с типом Place
    
    static func saveObject(_ place: Place) {
        
        // сохраняем в базу данных
        try! realm.write() {
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place){
        
        try! realm.write(){
            realm.delete(place)
        }
    }
}


