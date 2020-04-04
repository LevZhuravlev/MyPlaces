//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 29/03/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import Foundation

// в качестве моделей данных обычно используют структуры, так как они
// не требуют создание инициализаторов, потому что имеют встроенный
// то есть нам необходио будет перечислить все необходимые свойства
// и при создании экземпляра структуры нам будет доступен инициализатор
// со всеми нашими свойствами в виде параметров
    
    
struct Place {
    
    // для начала делаем описание
    // полей нашей модели исходя
    // из внешнего вида нашего приложения
    
    var name: String
    var location: String
    var type: String
    var image: String
    // картинка имеет тип строки так как
    // к изображению мы обращаемся через имя файла
    

    // Лайфхак по генерации тестовых записей
    // чтобы не делать тестовые записи в ручную
    // просто автоматизируем этот процесс
    
    // Данный метод лучше сразу сделать статичным
    // то есть методом всей стурктуры

static let restaurantNames = [
"Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
"Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
"Speak Easy", "Morris Pub", "Вкусные истории",
"Классик", "Love&Life", "Шок", "Бочка"]

   
    
static func getPlaces() -> [Place] {
    
    var places = [Place]()
    
    // цикл который последовательно перебирает
    // все элементы массива restaurantNames
    // и создавать элементы типа Place
    
    for place in restaurantNames {
        places.append(Place(name: place, location: "Москва", type: "ресторан", image: place))
    }
    
     
    return places
}}
