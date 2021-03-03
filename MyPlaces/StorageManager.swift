//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 11/04/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import RealmSwift

// Realm
let realm = try! Realm()


class StorageManager {
    
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


