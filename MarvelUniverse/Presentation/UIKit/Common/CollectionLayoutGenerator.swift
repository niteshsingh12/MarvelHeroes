//
//  CollectionlayoutGenerator.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import UIKit

struct CollectionLayoutGenerator {
    
    static func generateSquadSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .estimated(140))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return createSectionHeaders(with: layoutGroup)
    }
    
    static func generateHeroesSection(with env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = UIColor.systemBackground
        config.headerMode = .supplementary
        config.itemSeparatorHandler = .none

        let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(34))

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HeaderView.sectionHeaderElementKind,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        
        return section
    }
    
    static func createSectionHeaders(with layoutGroup: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(34))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HeaderView.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}

