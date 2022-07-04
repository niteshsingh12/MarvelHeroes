//
//  MarvelHeroDAO.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 02/07/22.
//

import Foundation
import CoreData

protocol HeroDAO {
    func addHero(_ hero: MarvelHero) async -> MarvelHero
    func getAllHeroes() async throws -> [MarvelHero]
    func deleteHero(_ hero: MarvelHero) async throws -> Bool
    func checkIfHeroInSquad(_ hero: MarvelHero) async throws -> Bool
}

class MarvelHeroDAO: CoreDataDAO<MarvelHero, MarvelHeroEntity>, HeroDAO {

    func getAllHeroes() async throws -> [MarvelHero] {
        try await get()
    }
    
    func addHero(_ hero: MarvelHero) async -> MarvelHero {
        await add(hero)
    }
    
    func deleteHero(_ hero: MarvelHero) async throws -> Bool {
        try await delete(hero)
    }
    
    func checkIfHeroInSquad(_ hero: MarvelHero) async throws -> Bool {
        try await checkIfEntityAdded(hero)
    }
    
    override func encode(entity: MarvelHero, into object: inout MarvelHeroEntity) {
        object.encode(entity: entity)
    }
    
    override func decode(object: MarvelHeroEntity) -> MarvelHero {
        return object.decode()
    }

    override var sortDescriptors: [NSSortDescriptor]? {
        return [
            NSSortDescriptor(keyPath: \MarvelHeroEntity.name, ascending: true)
        ]
    }
}
