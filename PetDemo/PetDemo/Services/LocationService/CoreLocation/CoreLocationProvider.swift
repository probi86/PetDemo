//
//  CoreLocationProvider.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import Foundation
import Combine
import CoreLocation

enum CoreLocationProviderError: Error {
    case notAuthorized
}

class CoreLocationProvider: NSObject, LocationProviding, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    private var locationSubject = PassthroughSubject<(latitude: Double, logitude: Double), Error>()
    private var authorizationSubject = PassthroughSubject<Bool, Error>()
    
    private var cancellables = [AnyCancellable]()
    
    //MARK: - LocationProviding
    
    func getLocation() -> AnyPublisher<(latitude: Double, logitude: Double), Error> {
        
        locationManager.delegate = self
        
        askForPermissionIfNeeded().sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.locationSubject.send(completion: .failure(error))
            default:
                break
            }
        } receiveValue: { [weak self] authorized in
            self?.locationManager.requestLocation()
        }
        .store(in: &cancellables)
        
        return locationSubject.eraseToAnyPublisher()
    }
    
    //MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.first {
            locationSubject.send((l.coordinate.latitude, l.coordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.send(completion: .failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationSubject.send(true)
        default:
            authorizationSubject.send(completion: .failure(CoreLocationProviderError.notAuthorized))
        }
    }
    
    //MARK: - Private
    
    private func askForPermissionIfNeeded() -> AnyPublisher<Bool, Error> {
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return Just(true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return authorizationSubject.eraseToAnyPublisher()
        default:
            return Fail(error: CoreLocationProviderError.notAuthorized)
                .eraseToAnyPublisher()
        }
    }
    
    
}
