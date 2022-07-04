//
//  HeroesViewController+Layout.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import UIKit

//MARK: Compositional Layout

extension HeroesViewController {
    
    /*
     Method creates compositional layout based on section index, for squad cells it fetches already created layout from CollectionLayoutGenerator which creates 3 cells horizontally in list view, and for heroes section, it creates UICollection List View Cell sections
     */
    func createLayoutForListCollectionView() -> UICollectionViewCompositionalLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = self.dataSource.sectionIdentifier(for: sectionIndex) else { return nil }
            
            switch section {
                case .squadHero:
                    return CollectionLayoutGenerator.generateSquadSection()
                    
                case .hero:
                    return CollectionLayoutGenerator.generateHeroesSection(with: layoutEnvironment)
            }
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
}
