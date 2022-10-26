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
    private var coordinator: PetListCoordinator
    private var apiServiceProvider: PetAPIServiceProviding
    private var dataPersistingProvider: PetDataPersistingProviding
    private var locationProvider: LocationProviding
    
    @Published private(set) var pets = [Pet]()
    @Published private(set) var isReloading = false
    @Published private(set) var isLoadingNextPage = false
    @Published private(set) var loadingError: Error?
    @Published private(set) var morePagesAvailable = false
     
    private var lastLatitude: Double = 0
    private var lastLongitude: Double = 0
    private var paginationInfo: PetPagination? {
        didSet {
            if let info = paginationInfo {
                morePagesAvailable = info.current_page < info.total_pages
            }
        }
    }
    
    var cancellables = [AnyCancellable]()
    private var fetchPersistedPetsCancellable: AnyCancellable?
    
    //MARK: - Lifecycle
    
    init(
        coordinator: PetListCoordinator,
        apiServiceProvider: PetAPIServiceProviding,
        dataPersistingProvider: PetDataPersistingProviding,
        locationProvider: LocationProviding
    ) {
        self.coordinator = coordinator
        self.apiServiceProvider = apiServiceProvider
        self.dataPersistingProvider = dataPersistingProvider
        self.locationProvider = locationProvider
        
        isReloading = false
        isLoadingNextPage = false
    }
    
    //MARK: - Public
    
    func fetchSavedPets() {
        fetchPersistedPetsCancellable = dataPersistingProvider.fetchPets()
            .sink(receiveCompletion: { [weak self] _ in
                self?.fetchPersistedPetsCancellable = nil
            }, receiveValue: { [weak self] pets in
                self?.pets = pets
            })
        fetchPersistedPetsCancellable?.store(in: &cancellables)
    }
    
    func reloadPets(withLocation: Bool = false) {
        
        fetchPersistedPetsCancellable?.cancel()
        
        isReloading = true
        loadingError = nil
        
        if withLocation {
            lastLatitude = 0
            lastLongitude = 0
            
            locationProvider.getLocation()
                .first()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.reloadPets(withLocation: false)
                    }
                } receiveValue: {[weak self] tuple in
                    self?.lastLatitude = tuple.latitude
                    self?.lastLongitude = tuple.longitude
                    self?.reloadPets(withLocation: false)
                }
                .store(in: &cancellables)
        } else {
            apiServiceProvider.loatPets(latitude: lastLatitude, longitude: lastLongitude, page: nil)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.loadingError = error
                    default:
                        break
                    }
                    
                    self?.isReloading = false
                    
                }, receiveValue: { [weak self] petResponse in
                    print("Loaded pets")
                    self?.pets = petResponse.animals
                    if let pets = self?.pets {
                        self?.dataPersistingProvider.store(pets: pets)
                    }
                    self?.paginationInfo = petResponse.pagination
                })
                .store(in: &cancellables)
        }
    }
    
    func loadNextPage() {
        guard let pagination = paginationInfo else {
            reloadPets()
            return
        }
        
        if isLoadingNextPage {
            return
        }
        
        if pagination.current_page < pagination.total_pages {
            isLoadingNextPage = true
            
            apiServiceProvider.loatPets(latitude: lastLatitude, longitude: lastLongitude, page: pagination.current_page + 1)
                .delay(for: 2.0, scheduler: OperationQueue.main) //Just to be able to see the spinner
                .sink { [weak self] _ in
                    self?.isLoadingNextPage = false
                } receiveValue: { [weak self] petResponse in
                    print("Loaded next page")
                    self?.pets.append(contentsOf: petResponse.animals)
                    if let pets = self?.pets {
                        self?.dataPersistingProvider.store(pets: pets)
                    }
                    self?.paginationInfo = petResponse.pagination
                }
                .store(in: &cancellables)
        }
    }
    
    func selected(pet: Pet) {
        coordinator.showDetailFor(pet: pet)
    }
}
