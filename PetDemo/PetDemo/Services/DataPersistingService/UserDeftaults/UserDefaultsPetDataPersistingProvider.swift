//
//  UserDefaultsPetDataPersister.swift
//  PetDemo
//
//  Created by Peter Robert on 26.10.2022.
//

import Foundation
import Combine

class UserDefaultsPetDataPersistingProvider: PetDataPersistingProviding {
    
    private let petsKey = "pets"
    
    var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    //MARK: - PetDataPersistingProviding
    
    func store(pets: [Pet]) {
        do {
            let data = try JSONEncoder().encode(pets)
            userDefaults.set(data, forKey: petsKey)
            userDefaults.synchronize()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func fetchPets() -> AnyPublisher<[Pet], Never> {
        if let petsData = userDefaults.data(forKey: petsKey) {
            do {
                let pets = try JSONDecoder().decode([Pet].self, from: petsData)
                return Just(pets).eraseToAnyPublisher()
            } catch {
                print("Failed to decode pets: \(error)")
            }
        }
        return Just([Pet]()).eraseToAnyPublisher()
    }
}
