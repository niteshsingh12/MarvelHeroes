//
//  HeroDAOTests.swift
//  MarvelUniverseTests
//
//  Created by Nitesh Singh on 01/07/22.
//

import Foundation
import XCTest
@testable import MarvelUniverse

class HeroDAOTests: XCTestCase {

    var storage: CoreDataManager!

    var heroes: [MarvelHero] {
        guard let mockData = FakeStub.generateFakeDataFromJSONWith(fileName: "SuccessHeroesJSON") else {
            XCTFail("Mock Generation Failed")
            fatalError()
        }
        
        var fetchedHeroes = [MarvelHero]()
        do {
            let response = try JSONDecoder().decode(DataWrapper<[MarvelHero]>.self, from: mockData)
            fetchedHeroes = response.data.results
        } catch {
            XCTFail("JSON Decoding Failed")
        }
        return fetchedHeroes
    }

    var hero: MarvelHero!

    override func setUpWithError() throws {
        hero = heroes.randomElement()
        self.storage = CoreDataManager.sharedTest
    }

    override func tearDown() async throws {
        let heroesDAO = MarvelHeroDAO(storage: CoreDataManager.sharedTest)
        let dbHeroes = try await heroesDAO.getAllHeroes()
        for hero in dbHeroes {
            _  = try await heroesDAO.delete(hero)
        }
    }

    /*
     Adds hero, then fetches list of all heroes to check if count matches to 1 & fetched hero name is sut's hero
     */
    func test_createHeroInCoreData_checkByNameProperty() async throws {
        
        let dao = MarvelHeroDAO(storage: CoreDataManager.sharedTest)
        _ = await dao.addHero(hero)
        let coreDataHeroes = try await dao.getAllHeroes()
        XCTAssertEqual(coreDataHeroes.count, 1)
        XCTAssertEqual(coreDataHeroes.first?.name, hero.name)
    }

    /*
     Adds hero, then removes same hero then checks if database heroes count is 0
     */
    func test_removeHeroFromCoraData() async throws {
        
        let dao = MarvelHeroDAO(storage: CoreDataManager.sharedTest)

        _ = await dao.addHero(hero)
        _  = try await dao.delete(hero)

        let dbHeroes = try await dao.getAllHeroes()
        XCTAssertEqual(dbHeroes.count, 0)
    }
}
