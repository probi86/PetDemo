//
//  UserDefaultsPetDataPersistingTests.swift
//  PetDemoTests
//
//  Created by Peter Robert on 26.10.2022.
//

import XCTest
import Combine
@testable import Pets

final class UserDefaultsPetDataPersistingTests: XCTestCase {
    
    var petsToStore: [Pet]!
    var userDefaultsPersister = UserDefaultsPetDataPersistingProvider()
    var cancellables = [AnyCancellable]()

    override func setUpWithError() throws {
        if let data = TestJsons.jsonStringFromDocs.data(using: .utf8) {
            do {
                let response = try JSONDecoder().decode(PetResponse.self, from: data)
                petsToStore = response.pets
            } catch {
                throw error
            }
        } else {
            throw PetTestError.genericError("Test json string doesn't exist or cannot be converted to data")
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        petsToStore = nil
    }
    
    func testStoreAndFetchAreTheSame() {
        userDefaultsPersister.store(pets: petsToStore)
        
        let expectation = expectation(description: "StoreFetch")
        
        var decodeError: Error?
        var storedData: Data?
        var fetchedData: Data?
        
        userDefaultsPersister.fetchPets().sink { pets in
            do {
                storedData = try JSONEncoder().encode(self.petsToStore)
                fetchedData = try JSONEncoder().encode(pets)
            } catch {
                decodeError = error
            }
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 0.2)
        
        XCTAssertNil(decodeError)
        XCTAssertEqual(storedData, fetchedData, "The stored and fetched pets are different")
    }

    func testStoreFetchPerformance() throws {
        // This is an example of a performance test case.
        
        
        self.measure {
            // Put the code you want to measure the time of here.
            userDefaultsPersister.store(pets: petsToStore)
            let expectation = expectation(description: "StoreFetchMeasure")
            
            userDefaultsPersister.fetchPets().sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
            
            waitForExpectations(timeout: 0.2)
        }
    }

}
