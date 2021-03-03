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
    var previousLocation: CLLocation? {didSet{startTrackingUserLocation()}}
    var directionsArray: [MKDirections]   = []
    
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
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAutoriztion()
        }
        
        else {
            alertLocationAutorization()
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // метод проверяющий работу статуса служб геолокации
    private func checkLocationAutoriztion() {
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            if incomeSegueIdentefier == "getAdress" { mapView.showsUserLocation = true }
            break
            
        case .authorizedAlways:
            if incomeSegueIdentefier == "getAdress" { mapView.showsUserLocation = true }
            break
        
        case .denied:
            alertLocationAutorization()

            break
        case .restricted:
            alertLocationAutorization()
            break

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        
        @unknown default: print("all works")
            
        }
    }
      
    private func setupPlacemark() {
    
        guard let location = place.location else {
            return
        }
        
        let geocoder = CLGeocoder()
        
        // данный класс преобразует координаты долготы и широты
        // в удобный для пользователя вид (в название города улицы ...)
        // и наоборот

        geocoder.geocodeAddressString(location) { (placemarks, error) in
           
            if let error = error {
                print (error);
                return
            }

            guard let placemarks = placemarks else {return}
            
            let placemark = placemarks.first
  
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
        
            guard let placemarkLocation = placemark?.location else {
                return
            }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    
    private func alertLocationAutorization() {
        
        let alertController = UIAlertController(title: "Your location is not Avalable" , message: "Please go to Settings -> Privacy -> Location Services and Turn it ON", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okButton)
        present(alertController, animated: true)
        locationButton.isHidden = true}
    
    // метод определения местоположения пользователя
    private func showUserLocation() {
            
            checkLocationServices()
            
            if let location = locationManager.location?.coordinate {
                
                var region = MKCoordinateRegion(center: location,
                latitudinalMeters: 300,
                longitudinalMeters: 300)

                if wayToDrive == 2 {
                region = MKCoordinateRegion(center: location,
                    latitudinalMeters: 100,
                    longitudinalMeters: 100)
                }
                
                mapView.setRegion(region, animated: true)

            }
    }
    
    // метод для камеры отслежнивания движения
    private func startTrackingUserLocation() {
       
        guard let previousLocation = previousLocation else {
            return
        }

        let center = getCenterLocation(for: mapView)
       
        guard center.distance(from: previousLocation) > 50 else {
            return
        }
        self.previousLocation = center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            self.showUserLocation()
        }
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
    
    // метод отчистки карты от ненцжных маршрутов
    private func resetMapView(withNew directions: MKDirections) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    // метод определяющий координаты центра экрана
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude // широта
        let longitude = mapView.centerCoordinate.longitude // долгота
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func getDirections(){
        
        guard let location = locationManager.location?.coordinate
            else {
            alertController(title: "Error", message: "Your location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        
        guard let request = createDirectionRequest(from: location) else {alertController(title: "Error", message: "Destination is not found"); return}

        let directions = MKDirections(request: request)
        
        resetMapView(withNew: directions)
        
        directions.calculate { ( response, error) in
            
            if let error = error  {
                print (error)
                return
            }
            
            guard let response = response else {
                self.alertController(title: "Error", message: "Destination is not avalible")
                return
            }
            
            // объект response содержит в себе
            // массив routes с маршрутами
            
            for route in response.routes {
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect( route.polyline.boundingMapRect, animated: true)
                
                let distance = String(format: "%.1f", route.distance / 1000)
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
                }
                
                else if timeHour == 0 && timeMin != 0 {
                    self.timeToPlace.text = "Time to place: \(timeMin) min"
                }
                
                else if timeHour != 0 && timeMin == 0 {
                    self.timeToPlace.text = "Time to place: \(timeHour) h"
                }
                
                else if timeHour != 0 && timeMin == 0 {
                    self.timeToPlace.text = "Time to place: \(timeHour) h \(timeMin) min"
                }
                
                self.distanceToPlace.text = "Distance \(distance) km"
                
            }
        }
    }
     
    // логика запроса на прокладку маршрута
    private func createDirectionRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destanationCoordinate = placeCoordinate
            else {return nil}
        
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destanationCoordinate)
        let request = MKDirections.Request()
     
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        
        if wayToDrive == 1 {
            request.transportType = .automobile
        }
        
        else if wayToDrive == 2 {
            request.transportType = .walking
        }
        
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    private func alertController(title: String,  message:  String) {
           
           let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
           let okButton = UIAlertAction(title: "OK", style: .default)
           
           alertController.addAction(okButton)
           present(alertController, animated: true)
           }
    
    @IBAction func closeMap() {
        dismiss(animated: true)
    }
    
    @IBAction func centerViewInUserLocation(_ sender: Any) {
        showUserLocation()
    }
    
    @IBAction func doneButtonPresed(_ sender: Any) {
        mapViewControllerDelegate?.getAddress(addressLabel.text)
        dismiss(animated: true)
    }
    
    @IBAction func goButtonPressed() {
        getDirections()
    }
    
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
        
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
       
        if incomeSegueIdentefier == "showPlace" && previousLocation != nil {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.getDirections()
            }
        }
        
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            
            if let error = error {print("error"); return}
            

            guard let placemarks = placemarks else {return}
            
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                
                if streetName != nil && buildNumber != nil {
                 self.addressLabel.text = "\(streetName!), \(buildNumber!)"
                }
                else if streetName != nil  {self.addressLabel.text = "\(streetName!)"}
                else {
                    self.addressLabel.text = ""
                }
        }
    }
    
    // метод отвечающий за отображение аннотации
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentefier) as? MKPinAnnotationView
      
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentefier)
            annotationView?.canShowCallout = true
            
        }
        
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
