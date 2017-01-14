//
//  ViewController.swift
//  CourseraIOSC4W4P
//
//  Created by Leyenda Software on 11/28/16.
//  Copyright © 2016 Mauricio Jacobo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var myView: UIView!
    @IBOutlet weak var myMap: MKMapView!
    private let myLocManager  = CLLocationManager()
    private var lastLocation: CLLocation!
    private var traveledDistance:Double = 0
    private var count  = 0
    private var numPin = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myLocManager.delegate = self
        myLocManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocManager.distanceFilter = 50.0
        myMap.frame = myView.bounds
        myLocManager.requestAlwaysAuthorization()
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Restricted Access to location")
            myLocManager.stopUpdatingLocation()
            myMap.showsUserLocation = false
        case .denied:
            print("User denied access to location")
            myLocManager.stopUpdatingLocation()
            myMap.showsUserLocation = false
        case .notDetermined:
            print("Status not determined")
            myLocManager.stopUpdatingLocation()
            myMap.showsUserLocation = false
        default:
            print("Allowed to location Access")
            myLocManager.startUpdatingLocation()
            myMap.showsUserLocation = true
            myMap.userTrackingMode = MKUserTrackingMode.follow
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 250, 250)
        myMap.setRegion(coordinateRegion, animated: true)
        count += 1
        if (count == 1) {
            lastLocation = location
        }
        
        if (( location.distance(from: lastLocation)) > 50.0 ) {
            if( numPin != 0 ) {
                traveledDistance += location.distance(from: lastLocation)
            }
            addMarker(myPinCoord: location.coordinate, distance: traveledDistance)
            lastLocation = location
            print("----- PIN")
            numPin += 1
        }
        
        print("++++++   \(count)")
        print("----->   \(location)")
        print("------   DR: " + String(format: " %f", traveledDistance))
        print("-----D   " + String(format: " Distancia: %f", location.distance(from: lastLocation)))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alerta = UIAlertController(title: "ERROR", message: "error \(error.localizedDescription)", preferredStyle: .alert)
        let accionOK = UIAlertAction(title: "OK", style: .default, handler:
            { accionOK in
                //...
        })
        alerta.addAction(accionOK)
        self.present(alerta, animated: true, completion: nil)
    }
    

    @IBAction func changeMapToSat(_ sender: Any) {
        myMap.mapType = MKMapType.satellite
    }
    
    @IBAction func changeMapToNor(_ sender: Any) {
        myMap.mapType = MKMapType.standard
    }
    
    @IBAction func changeMapToHib(_ sender: Any) {
        myMap.mapType = MKMapType.hybrid
    }
    
    func addMarker(myPinCoord: CLLocationCoordinate2D, distance: Double){
        let pin        = MKPointAnnotation()
        pin.title      = String.init(format: "( %.4f, %.4f )", myPinCoord.latitude, myPinCoord.longitude)
        print(pin.title ?? " Nil ")
        pin.subtitle   = String.init(format: "Distancia recorrida: %.2f m.", distance)
        print(pin.subtitle ?? " Nil ")
        pin.coordinate = myPinCoord
        myMap.addAnnotation(pin)
    }
    
}

