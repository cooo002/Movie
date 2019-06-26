//
//  TheaterViewController.swift
//  MovieChart
//
//  Created by 김재석 on 26/06/2019.
//  Copyright © 2019 김재석. All rights reserved.
//

import Foundation
import MapKit

class TheaterViewController: UIViewController {
    var param:NSDictionary!
    
    @IBOutlet weak var MKMapView: MKMapView!
    
    override func viewDidLoad() {
        self.navigationItem.title = self.param["상영관명"] as! String
        
        let lat = (param?["위도"] as!  NSString).doubleValue
        let lng = (param?["경도"] as!  NSString).doubleValue
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        let regionRadius: CLLocationDistance = 100
        
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        self.MKMapView.setRegion(coordinateRegion, animated: true)
        
    }
}
