//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 29/03/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?

 let restaurantNames = [
"Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
"Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
"Speak Easy", "Morris Pub", "Вкусные истории",
"Классик", "Love&Life", "Шок", "Бочка"]


    func savePlaces() {
    
    for place in restaurantNames {
        
        let image = UIImage(named: place)
        guard let imageData = image?.pngData() else {return}
        
        
        // создаем в цикле экземпляр нашей модели данных
        let newPlace = Place()
        
        // и теперь присоим свойствам экземпляра соответствующие значения
            
        newPlace.name = place
        newPlace.location = "Moscow"
        newPlace.type = "Restaurant"
        newPlace.imageData = imageData
        
        }
    }
}


