//
//  LocationServiceProtocol.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import Combine

public protocol LocationProviding {
    func getLocation() -> AnyPublisher<(latitude: Double, longitude: Double), Error>
}
