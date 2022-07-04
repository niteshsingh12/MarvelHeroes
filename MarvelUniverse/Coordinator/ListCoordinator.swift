//
//  ListCoordinator.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import UIKit

protocol ListBaseCoordinator: Coordinator {
    func moveToHeroDetailWith(hero: MarvelHero)
    func moveBackToListPage()
}

protocol ListBaseCoordinated {
    var coordinator: ListBaseCoordinator? { get }
}

final class ListCoordinator: ListBaseCoordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: AppBaseCoordinator?
    lazy var rootViewController: UINavigationController = UINavigationController()
    lazy var childCoordinators: [Coordinator] = []
    
    var factory = DependencyFactory()
    
    // MARK: - Methods
    
    func start() -> UINavigationController {
        
        let heroesViewController = factory.createHeroesListViewController()
        heroesViewController.coordinator = self
        rootViewController = UINavigationController(rootViewController: heroesViewController)
        return rootViewController
    }
    
    func moveToHeroDetailWith(hero: MarvelHero) {
        let detailViewController = factory.createDetailViewController(hero: hero)
        navigationRootViewController?.pushViewController(detailViewController, animated: true)
        configureNavigation()
    }
    
    func moveBackToListPage() {
        navigationRootViewController?.popViewController(animated: true)
        navigationRootViewController?.navigationBar.isHidden = false
    }
    
    func didFinish(_ child: Coordinator) {
        removeChild(child)
    }
    
    // MARK: - Navigation Appearance
    
    private func configureNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        appearance.shadowColor = .clear

        let navigationBar = navigationRootViewController!.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        navigationBar.isHidden = false
    }
    
    private func hideNavigationBar() {
        let navigationBar = navigationRootViewController!.navigationBar
        navigationBar.isHidden = true
    }
}
