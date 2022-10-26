//
//  AnimalDetailViewModel.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import Foundation
import Core

class PetDetailViewModel {
    
    private var apiServiceProvider: PetAPIServiceProviding
    private var locationProvider: LocationProviding
    private var dataPersistingProvider: PetDataPersistingProviding
    
    private(set) var pet : Pet
    
    init(
        apiServiceProvider: PetAPIServiceProviding,
        locationProvider: LocationProviding,
        dataPersistingProvider: PetDataPersistingProviding,
        pet: Pet
    ) {
        self.pet = pet
        self.apiServiceProvider = apiServiceProvider
        self.dataPersistingProvider = dataPersistingProvider
        self.locationProvider = locationProvider
    }
    
}
