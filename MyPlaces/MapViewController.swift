//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 06/05/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var place = Place()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlacemark()
        
        print("________", place)
    }
    
    
    // метод закрытия окна
    @IBAction func closeMap() {
        dismiss(animated: true)
    }
    
    
    // метод отображения метки на карте
    private func setupPlacemark() {
    
    // сначала мы проверяем есть ли у
    // объекта, который мы открываем, адрес
        
        guard let location = place.location else { return }
        
        // далее создаем экземпляр класса CLGeocoder
        // который отвечает за преобразование
        // географических координат и географических названий
        
        let geocoder = CLGeocoder()
        
        // данный класс может преобразовать координаты долготы и широты
        // в удобный для пользователя вид (в название города улицы ...)
        // и наоборот

        // в нашем случае класс будет преобразовывать
        // название в координаты широты и долготы, чтобы
        // определить место положение на карте, для
        // этого будет использоваться метод: geocodeAddressString
        // в качестве первого параметра в него подается то что из наз  вания
        // будет переводиться в метку
        // в качестве второго параметра будет создаваться массив
        // найденных соответсвующих названию меток
        // или ошибка если метки не были найдены
        // если запрос происходит успешно, то объект ошибки
        // возвращает нил ()
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
           
            // проверяем на наличие ошибки
            if let error = error { print (error); return}
            
            // если ошибки не было извлекаем опционал
            guard let placemarks = placemarks else {return}
             
            // так как нам не нужны все метки
            // теперь создаем константу в которую будет
            // передаваться значение первого элемента массива
            let placemark = placemarks.first
            
            // таким образом мы получили метку для карты
            
            // описываем метку
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            // привязываем аннотацию к точке на карте
            // сначала определяем местоположение маркера
            guard let placemarkLocation = placemark?.location else {return}
            
            annotation.coordinate = placemarkLocation.coordinate
            
            // далее задаем видимую область таким образом, чтобы были видны все метки
            
            self.mapView.showAnnotations([annotation], animated: true)
            
            // чтобы сделать аннотацию сразу выделенной, у аутлета mapView вызываем метод
            self.mapView.selectAnnotation(annotation, animated: true)
            
            
        }
    }
}


