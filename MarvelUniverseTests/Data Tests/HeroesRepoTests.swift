//
//  HeroesRepoTests.swift
//  MarvelUniverseTests
//
//  Created by Nitesh Singh on 01/07/22.
//

import XCTest
import Combine
@testable import MarvelUniverse

class HeroesRepoTests: XCTestCase {
    
    // custom urlsession for mock network calls
    var urlSession: URLSession!
    var cancellabels: Set<AnyCancellable>!
    var heroRepo: HeroesRepository!

    override func setUpWithError() throws {
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        cancellabels = Set<AnyCancellable>()
        
        let service: NetworkService = DefaultNetworkService(urlSession)
        heroRepo = DefaultHeroesRepository(service: service)
    }
    
    func test_fetchHeroes() throws {
        // Set mock data
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "SuccessHeroesJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "Expecting Successful Heroes Response")
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            
            switch completion {
                case .failure: ()
                case .finished: ()
            }
        }
        
        let valueHandler: (DataWrapper<[MarvelHero]>) -> Void = { (heroes) in
            XCTAssertTrue(!heroes.data.results.isEmpty, "Heroes should not be empty")
            XCTAssertEqual(heroes.data.results[0].name, "Ajak", "Ajak should be first hero")
            XCTAssertEqual(heroes.data.results.count, heroes.data.count, "Data count should match")
            expectation.fulfill()
        }
        
        heroRepo
            .fetchRemoteHeroes(with: .heroes(request: HeroRequest()))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellabels)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fail_fetchHeroes() throws {
        
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "EmptyJSON") else {
            XCTFail("Mock Generation Failed")
            return
        }
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "Expecting Error")
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            
            switch completion {
                case .failure(let error):
                    XCTAssertEqual(error, .decodingError)
                    expectation.fulfill()
                case .finished: ()
            }
        }
        let valueHandler: (DataWrapper<[MarvelHero]>) -> Void = { (heroes) in}
        
        heroRepo
            .fetchRemoteHeroes(with: .heroes(request: HeroRequest()))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellabels)
        
        wait(for: [expectation], timeout: 1)
    }
}
