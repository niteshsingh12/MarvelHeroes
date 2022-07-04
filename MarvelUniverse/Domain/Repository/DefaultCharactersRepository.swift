//
//  DefaultHeroesRepository.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import Combine

final class DefaultHeroesRepository: HeroesRepository {
    
    //MARK: Properties
    
    var service: NetworkService
    var dao: HeroDAO = MarvelHeroDAO()

    init(service: NetworkService) {
        self.service = service
    }

    //MARK: Remote Fetch Methods
    
    func fetchRemoteHeroes(with endpoint: MarvelEndpoint) -> AnyPublisher<HeroesResponseDataWrapper, NetworkError> {
        service.fetch(endpoint: endpoint)
    }
}

//MARK: Extension Local Fetch

extension DefaultHeroesRepository: HeroesRepositoryDAO {
    
    /*
     Fetches squad from core data
     */
    func getSquad() async throws -> [MarvelHero] {
        let savedSquad = try await self.dao.getAllHeroes()
        return savedSquad
    }
    
    /*
     Method adds new hero to squad (saves in core data)
     */
    func addToSquad(hero: MarvelHero) async -> MarvelHero {
        return await dao.addHero(hero)
    }

    /*
     Method removes hero from squad (deletes from core data)
     */
    func removeFromSquad(hero: MarvelHero) async throws -> Bool {
        return try await dao.deleteHero(hero)
    }
    
    func isHeroInSquad(hero: MarvelHero) async throws -> Bool {
        return try await dao.checkIfHeroInSquad(hero)
    }
}
