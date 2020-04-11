//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 29/03/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var rest_image: String?
    var image: UIImage?

static let restaurantNames = [
"Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
"Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
"Speak Easy", "Morris Pub", "Вкусные истории",
"Классик", "Love&Life", "Шок", "Бочка"]

    
static func getPlaces() -> [Place] {
    
    var places = [Place]()
    
    // цикл который последовательно перебирает все элементы массива restaurantNames
    // и создавать элементы типа Place
    
    for place in restaurantNames {
        places.append(Place(name: place, location: "Москва", type: "ресторан", rest_image: place, image: nil))
    }
    
    return places
}}
