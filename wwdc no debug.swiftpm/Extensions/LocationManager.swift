//import CoreLocation
//import SwiftUI
//import Foundation
//
//
//class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
//    private let locationManager = CLLocationManager()
//    private var completion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
//    
//    @Published var currentLocation: CLLocationCoordinate2D?
//    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//    }
//    
//    func getCurrentLocation() {
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//        } else {
//            startUpdatingLocation()
//        }
//    }
//    
//    private func startUpdatingLocation() {
//        locationManager.startUpdatingLocation()
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = CLLocationManager.authorizationStatus()
//        
//        switch authorizationStatus {
//        case .authorizedWhenInUse, .authorizedAlways:
//            startUpdatingLocation()
//        case .denied, .restricted:
//            completion?(.failure(LocationError.authorizationDenied))
//        default:
//            break
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            currentLocation = location.coordinate
//            locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//        completion?(.failure(error))
//    }
//    enum LocationError: Error {
//        case authorizationDenied
//    }
//}
