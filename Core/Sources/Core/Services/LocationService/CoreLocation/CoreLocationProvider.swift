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

public class CoreLocationProvider: NSObject, LocationProviding {
    
    private var locationManager = CLLocationManager()
    private var locationSubject = PassthroughSubject<(latitude: Double, longitude: Double), Error>()
    private var authorizationSubject = CurrentValueSubject<Bool, Error>(false)
    
    private var cancellables = [AnyCancellable]()
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    //MARK: - LocationProviding
    
    public func getLocation() -> AnyPublisher<(latitude: Double, longitude: Double), Error> {
        askForPermissionIfNeeded()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.locationSubject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] authorized in
                if authorized {
                    self?.locationManager.requestLocation()
                }
            }
            .store(in: &cancellables)
        
        return locationSubject
            .share()
            .eraseToAnyPublisher()
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

extension CoreLocationProvider: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.first {
            print("New location")
            locationSubject
                .send((l.coordinate.latitude, l.coordinate.longitude))
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject
            .send(completion: .failure(error))
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationSubject
                .send(true)
        case .notDetermined:
            return
        default:
            authorizationSubject
                .send(completion: .failure(CoreLocationProviderError.notAuthorized))
        }
    }
}
