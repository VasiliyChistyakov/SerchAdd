//
//  SearchMapViewController.swift
//  Add
//
//  Created by Чистяков Василий Александрович on 02.11.2021.
//

import UIKit
import MapKit
import CoreLocation

class SearchMapViewController: UIViewController {
    
    var destinationCoardinate: String!
    var annotationsArray = [MKPointAnnotation]()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        guard let destinationCoardinate = destinationCoardinate else { return }
        setupPlacemark(adressPlace: destinationCoardinate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }
    
    
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkAuthorization()
        } else {
            showAlertLocation(title: "У вас выключена служба геолокации", massage: "Хотите включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    
    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            showAlertLocation(title: "Вы запретили использование место положения", massage: "Хотите это изменить", url: URL(string: UIApplication.openSettingsURLString))
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    //URL(string: "App-Prefs:root=LOCATION_SERVICES")
    func showAlertLocation(title: String, massage: String, url: URL?) {
        let allet = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        
        let settingAction = UIAlertAction(title: "Настройки", style: .default) { (allet) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        allet.addAction(settingAction)
        allet.addAction(cancelAction)
        
        present(allet, animated: true, completion: nil)
    }
    
    
    
    @IBAction func getDirections(_ sender: Any) {
        
        guard let currentlocation = locationManager.location?.coordinate else { return }
        
        creaateDerectionRequest(satartCooardinate: currentlocation, destinationCoardinate: annotationsArray[0].coordinate)
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    
    private func setupPlacemark(adressPlace: String) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(adressPlace) { [self] (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(adressPlace)"
            guard let placemarkLocaion = placemark?.location else { return }
            annotation.coordinate = placemarkLocaion.coordinate
            
            annotationsArray.append(annotation)
            mapView.showAnnotations(annotationsArray, animated: true)
        }
    }
    
    private func creaateDerectionRequest(satartCooardinate: CLLocationCoordinate2D, destinationCoardinate: CLLocationCoordinate2D) {
        
        let startLocation = MKPlacemark(coordinate: satartCooardinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoardinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let deraction = MKDirections(request: request)
        deraction.calculate { (response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                return
            }
            var minRoute = response.routes[0]
            for route in response.routes{
                minRoute = (route.distance < minRoute.distance) ? route: minRoute
            }
            self.mapView.addOverlay(minRoute.polyline)
        }
    }
}

extension SearchMapViewController: MKMapViewDelegate, CLLocationManagerDelegate  {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.0500, longitudeDelta: 0.050  ))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
