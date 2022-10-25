//
//  AnimalDetailViewModel.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import Foundation

class PetDetailViewModel {
    
    private var apiServiceProvider: PetAPIServiceProviding
    private var locationProvider: LocationProviding
    
    private(set) var pet : Pet
    
    init(
        apiServiceProvider: PetAPIServiceProviding,
        locationProvider: LocationProviding,
        pet: Pet
    ) {
        self.pet = pet
        self.apiServiceProvider = apiServiceProvider
        self.locationProvider = locationProvider
    }
    
}
