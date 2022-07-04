//
//  CharacterViewModel.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import Combine
import SwiftUI

enum SquadOperation {
    case added
    case removed
}

enum ViewModelState {
    case loading
    case finished
    case error(Error)
}

/*
 Viewmodel is marked as @MainActor so all associated methods can run in main thread (unless told explicitly to run in separate thread)
 */

final class HeroesViewModel: ObservableObject {
    
    //MARK: Section
    
    enum Section: Int {
        case hero, squadHero
        
        func name() -> String {
            switch self {
                case .hero:
                    return "Heroes"
                case .squadHero:
                    return "My Squad"
            }
        }
    }
    
    //MARK: Properties
    
    @Published var heroes: [MarvelHero] = []
    @Published var squadHeroes: [MarvelHero] = []
    @Published var state: ViewModelState = .loading
    @Published var squadOperation: SquadOperation = .added
    private var cancellables = Set<AnyCancellable>()
    
    var result: [MarvelHero] = [] {
        didSet {
            heroes = result
        }
    }
    
    var limit = 20
    var offset: Int { result.count + limit }
    
    var heroesRepository: HeroesRepository & HeroesRepositoryDAO
    
    //:MARK: Initializer
    
    init(repository: HeroesRepository & HeroesRepositoryDAO) {
        self.heroesRepository = repository
    }
    
    //MARK: Methods
    
    /*
     Method fetches all super heros from Marvel API.
     */
    @MainActor func fetchRemoteHeroes() {
        
        state = .loading
        
        let valueHandler: (DataWrapper<[MarvelHero]>) -> Void = { [weak self] (response) in
            self?.result.append(contentsOf: response.data.results)
        }
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { [weak self] (completion) in
            switch completion {
                case .failure(let error) :
                    self?.state = .error(error)
                    print(error)
                case .finished:
                    self?.state = .finished
            }
        }
        
        let request = HeroRequest(limit: limit, offset: result.count)
        
        heroesRepository
            .fetchRemoteHeroes(with: .heroes(request: request))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)
    }
}

//MARK: Extension - Core Data

extension HeroesViewModel {
    /*
     Method fetches all squad heroes from core data.
     */
    @MainActor func getSquadHeroes() {
        Task {
            do {
                squadHeroes = try await heroesRepository.getSquad()
            } catch(let error) {
                print(error)
            }
        }
    }
    
    /*
     Method adds hero to squad. It calls core data and based on character id, requests it
     to add entity.
     */
    @MainActor func addHeroToSquad(hero: MarvelHero) {
        Task {
            let _ = await self.heroesRepository.addToSquad(hero: hero)
            squadOperation = .added
        }
    }
    
    /*
     Method removes hero from squad if it's present. It calls core data and based on character id, requests it
     to remove entity.
     */
    @MainActor func removeHeroFromSquad(hero: MarvelHero) {
        Task {
            let _ = try await self.heroesRepository.removeFromSquad(hero: hero)
            squadOperation = .removed
        }
    }
    
    /*
     Method checks if hero is in squad or not already. If in squad, core data fetch operation will be successful, and
     squadOperation publisher will be emitted with value .added which will inform the view to rerender. If hero
     is not added, error will be propagated in catch block and .removed will be emitted.
     */
    @MainActor func isHeroInSquad(hero: MarvelHero) {
        Task {
            do {
                let _ = try await self.heroesRepository.isHeroInSquad(hero: hero)
                squadOperation = .added
            } catch {
                squadOperation = .removed
            }
        }
    }
}


