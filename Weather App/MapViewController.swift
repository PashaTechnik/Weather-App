//
//  MapViewController.swift
//  Weather App
//
//  Created by Pasha on 01.11.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    private let reuseIdentifier = "MyIdentifier"
    private let locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        print(mapView.userLocation.coordinate)

        
        addGestureRecognizer()
    }
    

    func addGestureRecognizer() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        
        mapView.addGestureRecognizer(gesture)
    }

    @objc func handleLongTap(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            print("Tapped at Latitude: \(locationCoordinate.latitude), Longitude:\(locationCoordinate.longitude)")
            if gestureRecognizer.state != UIGestureRecognizer.State.began {
                return
            }
            mapView.removeAnnotations(mapView.annotations)
            
            let pin = MKPointAnnotation()
            pin.coordinate = locationCoordinate
            pin.title = "Show weather"
            mapView.addAnnotation(pin)

        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "id"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            let btn = UIButton(type: .detailDisclosure)
            btn.addTarget(self, action: #selector(getWeather), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    @objc func getWeather() {
        print("dddcdc")
    }

}


