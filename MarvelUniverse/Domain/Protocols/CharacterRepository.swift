//
//  HeroesRepository.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import Combine

typealias HeroesResponseDataWrapper = DataWrapper<[MarvelHero]>

protocol HeroesRepository {
    func fetchRemoteHeroes(with endpoint: MarvelEndpoint) -> AnyPublisher<HeroesResponseDataWrapper, NetworkError>
}

protocol HeroesRepositoryDAO {
    func getSquad() async throws -> [MarvelHero]
    func addToSquad(hero: MarvelHero) async -> MarvelHero
    func removeFromSquad(hero: MarvelHero) async throws -> Bool
    func isHeroInSquad(hero: MarvelHero) async throws -> Bool
}
