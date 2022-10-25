//
//  APIServiceProtocol.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import Combine

protocol PetAPIServiceProviding {
    func reloadPets(latitude: Double?, longitude: Double?, page: Int?) -> AnyPublisher<PetResponse, Error>
}
