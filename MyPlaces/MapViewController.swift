//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 06/05/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var place = Place()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlacemark()
        checkLocationAutoriztion()
        if (locationManager.location?.coordinate) != nil {}

    }
    override func viewDidAppear(_ animated: Bool) {
        checkLocationAutoriztion()

    }
    
    // метод проверяющий работу служб геолокации
    private func checkLocationServices() {
        
        // за работу свойств геолокации отвечает метод
        if CLLocationManager.locationServicesEnabled() {
            
            // этот метод возрващает булево значение
            // если службы геолокации доступны,
            // то в этой ветке будут выполняться
            // первичные установки для дальнейшей работы
            
            setupLocationManager()
            checkLocationAutoriztion()
        }
        
        else {
            
            // эта ветка отвечает за работу alert
            // контроллера, который будет объяснять
            // пользователю как включить службы геолокации
            
            alertLocationAutorization()
            
        }
    }
    
    // метод устанавливюий настройки геопозиции
    private func setupLocationManager() {
        
        // Настроим точность определения местоположения
        // пользователя с помощью свойства
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    // метод проверяющий работу статуса служб геолокации
    private func checkLocationAutoriztion() {
        
        // у класса CLLocationManager() есть метод
        // "autoriztionStatus" который, возвращает различные
        // состояния авторизации приложения, для служб геолокации
        // всего таких состояний имеется 5 и надо обработать каждое из них
        switch CLLocationManager.authorizationStatus(){
            
        case .authorizedWhenInUse:
            // приложению разрешенно использовать
            // геолокацию когда оно используется
            
            // будет отображать положение пользователя
            mapView.showsUserLocation = true
            break
            
        case .authorizedAlways:
            // приложению разрешенно использовать
            // геолокацию всегда
            
            // будет отображать положение пользователя
            mapView.showsUserLocation = true
            break
        
        case .denied:
            // приложению отказанно
            // использовать геолокацию
            
            alertLocationAutorization()

            break
        case .restricted:
            // используется когда устройство
            // не авторизованно для использования
            // служб геолокации
            
            alertLocationAutorization()
    
            break
        
        case .notDetermined:
            // статус не определен
            
            // будем запрашивать разрешение
            // на использование
            locationManager.requestWhenInUseAuthorization()
            
            // чтобы пользователь понимал зачем нам нужна
            //  меняем настройки в Info.plist
            break
        
        
        @unknown default: print("all works")
        }
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
    
    // метод открытия окна alert
    private func alertLocationAutorization() {
        
        let alertController = UIAlertController(title: "Your location is not Avalable" , message: "Please go to Settings -> Privacy -> Location Services and Turn it ON", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okButton)
        present(alertController, animated: true)
        locationButton.isHidden = true}
    
    // метод определения местоположения
    private func showUserLocation() {
          // сначала проверим наличие координат пользователя
            
            checkLocationServices()
            
            if let location = locationManager.location?.coordinate {
        
                // если их получиться определить, то определяем
                // регион для позиционирования карты
                
                let region = MKCoordinateRegion(center: location,
                                                latitudinalMeters: 1000,
                                                longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)}
    }
    
    // кнопка закрытия окна
    @IBAction func closeMap() {
        dismiss(animated: true)
    }
    
    // кнопка определения местоположения
    @IBAction func centerViewInUserLocation(_ sender: Any) {
        showUserLocation()
    }
    
    
    
}


extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAutoriztion()
    }
}
