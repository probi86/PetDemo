//
//  NSURLSessionAPIProvider.swift
//  PetDemo
//
//  Created by Peter Robert on 24.10.2022.
//

import Foundation
import Combine

class NSURLSessionPetAPIProvider: PetAPIServiceProviding {
    
    private struct Token: Codable {
        var token_type: String
        var expires_in: Int
        var access_token: String
        
        var expirationDate: Date?
    }
    
    private let apiKey: String
    private let apiSecret: String
    
    private let urlSession = URLSession.shared
    
    private var token: Token?
    
    private var tokenFetchPublisher: AnyPublisher<Token, Error>?
    
    init(
        apiKey: String,
        apiSecret: String
    ) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    //MARK: - APIServiceProviding
    
    func loatPets(latitude: Double?, longitude: Double?, page: Int?) -> AnyPublisher<PetResponse, Error> {
        
        var urlComponents = urlComponents(path: "/v2/animals")
        var queryItems = [URLQueryItem]()
        if let lat = latitude, let lng = longitude {
            queryItems.append(URLQueryItem(name: "location", value: "\(lat), \(lng)"))
        }
        if let p = page {
            queryItems.append(URLQueryItem(name: "page", value: "\(p)"))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let urlRequest = URLRequest(url: url)
        
        return makeAuthenticatedRequest(urlRequest, session: urlSession)
            .decode(type: PetResponse.self, decoder: JSONDecoder())
            .receive(on: OperationQueue.main)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Private
    
    private func makeAuthenticatedRequest(_ request: URLRequest, session: URLSession, remainingRetries: Int = 1) -> AnyPublisher<Data, Error> {
        return getBearerToken()
            .map { (t: Token) -> URLRequest in
                var authenticatedRequest = request
                authenticatedRequest.setValue("Bearer \(t.access_token)", forHTTPHeaderField: "Authorization")
                return authenticatedRequest
            }
            .flatMap({ r in
                return session.dataTaskPublisher(for: r)
                    .tryMap({ (data: Data, response: URLResponse) in
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                            if httpResponse.statusCode == 401 {
                                throw URLError(.userAuthenticationRequired)
                            } else {
                                throw URLError(.badServerResponse)
                            }
                        } else {
                            return data
                        }
                    })
            })
            .tryCatch({ [weak self] error -> AnyPublisher<Data, Error> in
                guard let self = self,
                      let urlError = error as? URLError,
                      urlError.code == .userAuthenticationRequired,
                      remainingRetries > 0
                else {
                    throw error
                }
                
                self.token = nil
                return self.makeAuthenticatedRequest(request, session: session, remainingRetries: remainingRetries - 1)
            })
            .eraseToAnyPublisher()
    }
    
    private func getBearerToken() -> AnyPublisher<Token, Error> {
        //Return the current token if not expired
        if let t = token {
            if let tokenValidFor = t.expirationDate?.timeIntervalSinceNow, tokenValidFor > 3598 { //TODO: Change this!
                return Just(t)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                token = nil
            }
        }
        
        //If we are already fetching, use that publisher, to avoid multiple refreshes
        if let existingFetchPublisher = tokenFetchPublisher {
            return existingFetchPublisher
        }
        
        //Otherwise clear the token and fetch a new token
        guard let url = urlComponents(path: "/v2/oauth2/token").url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        print("Refreshing token")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let str = "grant_type=client_credentials&client_id=\(apiKey)&client_secret=\(apiSecret)"
        request.httpBody = str.data(using: .utf8)
        
        let publisher = urlSession
            .dataTaskPublisher(for: request)
            .tryMap {[weak self] (data: Data, response: URLResponse) in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    print("Failed to refresh token")
                    self?.token = nil
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Token.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { [weak self] t in
                print("Refreshed token")
                self?.token = t
                self?.token?.expirationDate = Date(timeIntervalSinceNow: TimeInterval(t.expires_in))
            }, receiveCompletion: { [weak self] _ in
                self?.tokenFetchPublisher = nil
            })
            .share()
            .eraseToAnyPublisher()
            
        
        tokenFetchPublisher = publisher
        return publisher
    }
    
    private func urlComponents(path: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.petfinder.com"
        components.path = path
        return components
    }
}
