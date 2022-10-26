//
//  NSURLSessionPetAPIProviderTests.swift
//  PetDemoTests
//
//  Created by Peter Robert on 26.10.2022.
//

import XCTest
import Combine
@testable import PetDemo

final class NSURLSessionPetAPIProviderTests: XCTestCase {
    
    var goodCredentialsAPIProvider = URLSessionPetAPIServiceProvider(apiKey: "gZFOnrtkq6CL1mOB4xSwx2EacNHbnpESQjUR9xThTAcyVtNuLT", apiSecret: "jSRULM85xGveYMj1WKZQmPLaI8t4eZgzgFL6iMrf")
    var badCredentialsAPIProvider = URLSessionPetAPIServiceProvider(apiKey: "", apiSecret: "")
    
    var cancellables = [AnyCancellable]()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBadCredentialsLoad() throws {
        
        let expectation = expectation(description: "LoadWithGoodCredentials")
        
        var apiRequestError: Error?
        
        badCredentialsAPIProvider
            .loatPets(latitude: 0, longitude: 0)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    apiRequestError = error
                default:
                    break
                }
                expectation.fulfill()
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
        
        guard let urlError = apiRequestError as? URLError, urlError.code == .userAuthenticationRequired else {
            XCTFail("Bad credentials don't return .userAuthenticationRequired error")
            return
        }
    }

    func testGoodCredentialsLoad() throws {
        
        let expectation = expectation(description: "LoadWithGoodCredentials")
        
        var apiRequestError: Error?
        
        goodCredentialsAPIProvider
            .loatPets(latitude: 0, longitude: 0)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    apiRequestError = error
                default:
                    break
                }
                expectation.fulfill()
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5)
        
        if let urlError = apiRequestError as? URLError {
            XCTAssertTrue(urlError.code != .userAuthenticationRequired)
        }
    }

}
