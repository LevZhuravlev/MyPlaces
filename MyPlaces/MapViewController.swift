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
     
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // метод закрытия окна
    @IBAction func closeMap() {
        dismiss(animated: true)
        
    }
}


