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

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {
    
    var place = Place()
    var annotationIdentefier = "annotationIdentefier"
    var locationManager = CLLocationManager()
    var incomeSegueIdentefier = ""
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var placeCoordinate: CLLocationCoordinate2D?
    var wayToDrive: Int = 1
    var previousLocation: CLLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var timeToPlace: UILabel!
    @IBOutlet weak var distanceToPlace: UILabel!
    @IBOutlet weak var onCarOrOnFootSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = ""
        setupMapView()
        checkLocationAutoriztion()
        mapView.delegate = self
        if (locationManager.location?.coordinate) != nil {}
        timeToPlace.isHidden = true
        distanceToPlace.isHidden = true
        onCarOrOnFootSegment.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        if (locationManager.location?.coordinate) != nil {}
        setupMapView()
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
            if incomeSegueIdentefier == "getAdress" { mapView.showsUserLocation = true }
            break
            
        case .authorizedAlways:
            // приложению разрешенно использовать
            // геолокацию всегда
            
            // будет отображать положение пользователя
            if incomeSegueIdentefier == "getAdress" { mapView.showsUserLocation = true }
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
            
            self.placeCoordinate = placemarkLocation.coordinate

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
    
    // метод определения местоположения пользователя
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
    
    // метод настройки отображения окна карты
    private func setupMapView(){
        if incomeSegueIdentefier == "showPlace" {
            setupPlacemark()
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
        }
        else if incomeSegueIdentefier == "getAdress" {
            showUserLocation()
            goButton.isHidden = true
        }
    }
    
    // метод определяющий координаты центра экрана
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        // для определения координат надо знать широту и долготу
        let latitude = mapView.centerCoordinate.latitude // широта
        let longitude = mapView.centerCoordinate.longitude // долгота
        
        // нам необходимо вернуть координаты конкретной точки
        // поэтому инициализируем
        
        return CLLocation(latitude: latitude, longitude: longitude)
        
        // теперь у нас есть метод который возвращает координаты
        // точки находящиеся по центру экрана%
    }
    
    // метод логики прокладки маршрута
    private func getDirections(){
        
        // определим координаты местоположения пользователя
        guard let location = locationManager.location?.coordinate
            // если не доступно то выводим alert с ошибкой
            else { alertController(title: "Error", message: "Your location is not found"); return}
        
        // далее нам надо сделать запрос на построенние маршрута
        guard let request = createDirectionRequest(from: location) else {alertController(title: "Error", message: "Destination is not found"); return}
        
         // если все прошло успешно, то мы создаем маршрут на основе тех сведений, которые имеются в запросе
        let directions = MKDirections(request: request)
        
        // далее расчитаем маршрут
        directions.calculate { ( response, error) in
            
            // обработаем ошибку
            if let error = error  {
                print (error)
                return
            }
            
            // извлечем маршрут
            guard let response = response else {self.alertController(title: "Error", message: "Destination is not avalible"); return }
            
            // объект response содержит в себе
            // массив routes с маршрутами
            
            for route in response.routes {
                
                // массив routes содержит в себе один или несколько объектов
                // с типом MKRoute, каждый из которых представляет возможный
                // набор направлений
                
                // создаем на карте наложения со всеми доступными маршрутами
                
                self.mapView.addOverlay(route.polyline)
                
                // теперь сфокусируем карту таким образом
                // чтобы весь маршрут был виден целиком
                
                self.mapView.setVisibleMapRect( route.polyline.boundingMapRect , // определяет зону видимости карты
                                               animated: true)
                
                // далее поработаем с дополнительной информацией по маршруту
                let distance = String(format: "%.1f", route.distance / 1000) // длина маршрута
                let timeInterval = Int(route.expectedTravelTime)
                
                func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
                  return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
                }
                
                let converttimeInterval = secondsToHoursMinutesSeconds(seconds: timeInterval)
                print("Расстояние", distance, "км")
                print("Время", converttimeInterval)
                
                self.timeToPlace.isHidden = false
                self.distanceToPlace.isHidden = false
                self.onCarOrOnFootSegment.isHidden = false
                
                let timeHour = converttimeInterval.0
                let timeMin = converttimeInterval.1
                let timeSec = converttimeInterval.2
                
                if timeHour == 0 && timeMin == 0 && timeSec != 0 {
                self.timeToPlace.text = "Time to place: \(timeSec) sec"
                } else if timeHour == 0 && timeMin != 0 {
                self.timeToPlace.text = "Time to place: \(timeMin) min"
                } else if timeHour != 0 && timeMin == 0 {
                self.timeToPlace.text = "Time to place: \(timeHour) h"
                } else if timeHour != 0 && timeMin == 0 {
                self.timeToPlace.text = "Time to place: \(timeHour) h \(timeMin) min"
                }
                self.distanceToPlace.text = "Distance \(distance) km"
                
            }
        }

    }
     
    // логика запроса на прокладку маршрута
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        // возвращать метод будет настроенный запрос, который в последствии и будет использоваться
        // возврат будет опциональный так как не факт что мы его получим
        // все зависит от того сможем ли мы определить координаты места назначения
        
        // сначала определим место назначения
        guard let destanationCoordinate = placeCoordinate
            else {return nil}
        
        // точка начала движения
        let startingLocation = MKPlacemark(coordinate: coordinate)
        
        // точка конца движения
        let destination = MKPlacemark(coordinate: destanationCoordinate)
        
        // создадим объект запроса
        let request = MKDirections.Request()
        
        // данное свойство позволяет определить
        // начальную и конечную точку маршрута
        // а так же планируемый вид транспорта
        
        // будем использовать точки начала и конца маршрута
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        
        if wayToDrive == 1 {
        // тип траспорта
            request.transportType = .automobile }
        else if wayToDrive == 2 { request.transportType = .walking }
        
        // альтернативные маршруты
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    // метод открытия окна alert
    private func alertController(title: String,  message:  String) {
           
           let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
           let okButton = UIAlertAction(title: "OK", style: .default)
           
           alertController.addAction(okButton)
           present(alertController, animated: true)
           }
    
    // кнопка закрытия окна
    @IBAction func closeMap() {
        dismiss(animated: true)
    }
    
    // кнопка определения местоположения
    @IBAction func centerViewInUserLocation(_ sender: Any) {
        showUserLocation()
    }
    
    // кнопка сохранения указзанной локации
    @IBAction func doneButtonPresed(_ sender: Any) {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
    }
    
    // кнопка прокладки маршрута
    @IBAction func goButtonPressed() {
        getDirections()
    }
    
    // метод выбора способа передвижения
    @IBAction func onCarOnFoot(_ sender: Any) {
        
        switch onCarOrOnFootSegment.selectedSegmentIndex {
        case 0: self.wayToDrive = 1; getDirections();
        case 1: self.wayToDrive = 2; getDirections();
        default: return
        
        }
    }
    
}


extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAutoriztion()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // метод который вызывается при смене отображаемого региона
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // сначала определем текущие координаты по центру отображаемой области
        let center = getCenterLocation(for: mapView)
        
        // класс отвечающий за преобразование координат
        let geocoder = CLGeocoder()
        
        // вызываем метод класса CLGeocoder()
        // который будет преобразовывать
        // координаты в адрес
        // на вход метода подаются координаты
        // а на выходе получаем массив меток
        // или ошибку
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            // проверяем на наличие ошибок
            if let error = error {print("error"); return}
            
            // если ошибки нет, то нам нужно
            // извлечь массив меток
            
            guard let placemarks = placemarks else {return}
            
            // извлекаем первую метку
            let placemark = placemarks.first
            
            // теперь нам надо извлечь улицу и номер дома
            let streetName = placemark?.thoroughfare // улица
            let buildNumber = placemark?.subThoroughfare // дом
            
             // обнавлять интерфейс надо в основном потоке ассинхронно
            DispatchQueue.main.async {
                
                // значения дома и улицы будут опционпльными так как не всегда их можно определить по локации
                // поэтому прежде чем передать в лейбл название удицы и дома надо выполнить проверки
                
                if streetName != nil && buildNumber != nil {
                 self.addressLabel.text = "\(streetName!), \(buildNumber!)"
                }
                else if streetName != nil  {self.addressLabel.text = "\(streetName!)"}
                else {self.addressLabel.text = ""}
           
        }
    }
    
    // метод отвечающий за отображение аннотации
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {return nil}
        
        // далее создаем объект, который в последствии и будет возвращаться
        // и который и будет представлять из себя view с аннотацией на карте
        // чтобы не создавать новое представление при вызове данного метода
        // лучше переиспользовать ранее созданные аннотации этого типа
        // для этого мы создали annotationIdentefier
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentefier) as? MKPinAnnotationView
        
        // в случае если на карте не окажется ни одного представления
        // с аннотацией которое мы могли бы переиспользовать
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentefier)
            
            // для того чтобы использовать аннотацию в виде банера
            annotationView?.canShowCallout = true
            
        }
        
        // Изображение для аннотации
        // Делаем проверку на то что изображение есть
        if let imageData =  place.imageData {
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
              imageView.layer.cornerRadius = 10
              imageView.clipsToBounds = true
              imageView.image  = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
}
    
    // метод отвечающий за отображение маршрута на карте
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        
        
        // тем самым мы отрендерим наложение которое мы сделали ранее
        if wayToDrive == 1 {
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
        }
        else if wayToDrive == 2 { renderer.strokeColor = .red
            renderer.lineWidth = 2
        }
        return renderer
    }
    
}
