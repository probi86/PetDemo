//
//  Animal.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import Foundation

struct PetBreed: Codable {
    var primary: String
    var secondary: String?
    var mixed: Bool
    var unknown: Bool
}

struct PetPhotos: Codable {
    var small: String?
    var medium: String?
    var large: String?
    var full: String?
}

struct Pet: Codable {
    var id: Int
    var name: String
    var type: String
    var size: String
    var gender: String
    var status: String
    var distance: Double
    var photos: [PetPhotos]?
    var description: String?
    
    private var breeds: PetBreed
    
    var breed: String {
        breeds.primary
    }
    
    var petDetails: [(name: String, value: String)] {
        return [
            ("Type", type),
            ("Breed", breed),
            ("Size", size),
            ("Gender", gender),
            ("Status", status),
            ("Distance", distance == 0 ? "N/A" : "\(distance) mi")
        ]
    }
}

struct PetPagination: Codable {
    var countPerPage: Int
    var totalCount: Int
    var currentPage: Int
    var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case countPerPage = "count_per_page"
        case totalCount = "total_count"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

struct PetResponse: Codable {
    var pets: [Pet]
    var pagination: PetPagination
    
    enum CodingKeys: String, CodingKey {
        case pets = "animals"
        case pagination
    }
}
