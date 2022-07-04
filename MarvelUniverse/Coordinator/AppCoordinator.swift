//
//  MainCoordinator.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import UIKit

protocol AppBaseCoordinator: Coordinator {
    var listCoordinator: ListBaseCoordinator { get }
}

final class AppCoordinator: AppBaseCoordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: AppBaseCoordinator?
    
    lazy var listCoordinator: ListBaseCoordinator = ListCoordinator()
    lazy var rootViewController: UINavigationController  = UINavigationController()
    lazy var childCoordinators: [Coordinator] = []
    
    // MARK: - Methods
    
    func start() -> UINavigationController {
        let heroesViewController = listCoordinator.start()
        listCoordinator.parentCoordinator = self
        return heroesViewController
    }
    
    func didFinish(_ child: Coordinator) {
        removeChild(child)
    }
}
