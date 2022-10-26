//
//  PetTestUtils.swift
//  PetDemoTests
//
//  Created by Peter Robert on 26.10.2022.
//

import Foundation

enum PetTestError: Error {
    case genericError(String)
}

struct TestJsons {
    static let jsonStringFromDocs = """
    {
    "animals": [
    {
        "id": 124,
        "organization_id": "NJ333",
        "url": "https://www.petfinder.com/cat/nebula-124/nj/jersey-city/nj333-petfinder-test-account/?referrer_id=d7e3700b-2e07-11e9-b3f3-0800275f82b1",
        "type": "Cat",
        "species": "Cat",
        "breeds": {
            "primary": "American Shorthair",
            "secondary": null,
            "mixed": false,
            "unknown": false
        },
        "colors": {
            "primary": "Tortoiseshell",
            "secondary": null,
            "tertiary": null
        },
        "age": "Young",
        "gender": "Female",
        "size": "Medium",
        "coat": "Short",
        "name": "Nebula",
        "description": "Nebula is a shorthaired, shy cat. She is very affectionate once she warms up to you.",
        "photos": [
            {
                "small": "https://photos.petfinder.com/photos/pets/124/1/?bust=1546042081&width=100",
                "medium": "https://photos.petfinder.com/photos/pets/124/1/?bust=1546042081&width=300",
                "large": "https://photos.petfinder.com/photos/pets/124/1/?bust=1546042081&width=600",
                "full": "https://photos.petfinder.com/photos/pets/124/1/?bust=1546042081"
            }
        ],
        "status": "adoptable",
        "attributes": {
            "spayed_neutered": true,
            "house_trained": true,
            "declawed": false,
            "special_needs": false,
            "shots_current": true
        },
        "environment": {
            "children": false,
            "dogs": true,
            "cats": true
        },
        "tags": [
            "Cute",
            "Intelligent",
            "Playful",
            "Happy",
            "Affectionate"
        ],
        "contact": {
            "email": "petfindertechsupport@gmail.com",
            "phone": "555-555-5555",
            "address": {
                "address1": null,
                "address2": null,
                "city": "Jersey City",
                "state": "NJ",
                "postcode": "07097",
                "country": "US"
            }
        },
        "published_at": "2018-09-04T14:49:09+0000",
        "distance": 0.4095,
        "_links": {
            "self": {
                "href": "/v2/animals/124"
            },
            "type": {
                "href": "/v2/types/cat"
            },
            "organization": {
                "href": "/v2/organizations/nj333"
            }
        }
    }
    ],
    "pagination": {
    "count_per_page": 20,
    "total_count": 320,
    "current_page": 1,
    "total_pages": 16,
    "_links": {}
    }
    }
    """
}
