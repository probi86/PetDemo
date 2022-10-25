//
//  AnimalListViewModel.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import Foundation
import Combine

class PetListViewModel {
    
    //MARK: - IVars
    private var apiServiceProvider: PetAPIServiceProviding
    private var locationProvider: LocationProviding
    
    @Published private(set) var pets = [Pet]()
    @Published private(set) var isReloading = false
    @Published private(set) var isLoadingNextPage = false
    @Published private(set) var loadingError: Error?
    
    var cancellables = [AnyCancellable]()
    
    //MARK: - Lifecycle
    
    init(
        apiServiceProvider: PetAPIServiceProviding,
        locationProvider: LocationProviding
    ) {
        self.apiServiceProvider = apiServiceProvider
        self.locationProvider = locationProvider
        
        isReloading = false
        isLoadingNextPage = false
    }
    
    //MARK: - Public
    
    func reloadPets() {
        isReloading = true
        
        apiServiceProvider.reloadPets(latitude: 0, longitude: 0, page: nil)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Failed to laod pets: \(error)")
                    self?.loadingError = error
                default:
                    break
                }
                
                self?.isReloading = false
                
            }, receiveValue: { [weak self] petResponse in
                print("Loaded pets")
                self?.pets = petResponse.animals
            })
            .store(in: &cancellables)
    }
    
    func loadNextPage() {
        
    }
}
