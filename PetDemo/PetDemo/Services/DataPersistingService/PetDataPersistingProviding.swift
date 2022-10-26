//
//  PetDataPersisting.swift
//  PetDemo
//
//  Created by Peter Robert on 26.10.2022.
//

import Foundation
import Combine

protocol PetDataPersistingProviding {
    func store(pets: [Pet])
    func fetchPets() -> AnyPublisher<[Pet], Never>
}
