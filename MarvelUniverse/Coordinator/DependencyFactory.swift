//
//  DependencyFactory.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation

class DependencyFactory {
    
    func createHeroesListViewController() -> HeroesViewController {
        let homeVC = HeroesViewController(viewModel: createHeroesViewModel(), imageLoader: ImageLoader())
        return homeVC
    }
    
    func createHeroesViewModel() -> HeroesViewModel {
        return HeroesViewModel(repository: createRepository())
    }
    
    private func createRepository() -> HeroesRepository & HeroesRepositoryDAO {
        return DefaultHeroesRepository(service: createNetworkService())
    }
    
    private func createNetworkService() -> NetworkService {
        return DefaultNetworkService(URLSession(configuration: .default))
    }
}

extension DependencyFactory {
    
    func createDetailViewController(hero: MarvelHero) -> HeroDetailViewController {
        let detailVC = HeroDetailViewController(viewModel: createHeroesViewModel(), hero: hero, imageLoader: ImageLoader())
        return detailVC
    }
}
