//
//  HeroesViewController+CollectionView.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import UIKit

//MARK: Collection View Setup

extension HeroesViewController {
    
    /*
     CollectionListViewCell setup (used for hero cells)
     */
    private func heroCellRegistration() -> UICollectionView.CellRegistration<HeroListViewCell, MarvelHero> {
        
        return UICollectionView.CellRegistration<HeroListViewCell, MarvelHero> { (cell, indexPath, item) in
            cell.injectDependencies(imageRepository: self.imageLoader, hero: item)
        }
    }
    
    func setupCollectionView() {
        heroesCollectionView.register(SquadCell.self, forCellWithReuseIdentifier: SquadCell.reuseIdentifer)
        heroesCollectionView.delegate = self
        heroesCollectionView.register(HeaderView.self,
                                                forSupplementaryViewOfKind: HeaderView.sectionHeaderElementKind,
                                                withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    /*
     Setting up diffable data source
     */
    func setupDatasource() {
        
        let registeredCells = heroCellRegistration()
        
        dataSource = Datasource(collectionView: heroesCollectionView,
                                cellProvider: { (collectionView, indexPath, hero) in
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
                    
                case .hero:
                    let cell = collectionView.dequeueConfiguredReusableCell(using: registeredCells, for: indexPath, item: hero)
                    return cell
                    
                case .squadHero:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquadCell.reuseIdentifer, for: indexPath) as! SquadCell
                    cell.injectDependency(imageLoader: self.imageLoader, hero: hero)
                    return cell
            }
        })
        configureSupplementaryViews()
    }
    
    /*
     Setting up supplementary header view and header text
     */
    private func configureSupplementaryViews() {
        
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
                default :
                    
                    guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HeaderView.reuseIdentifier,
                        for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
                    
                    supplementaryView.headerLabel.text = section.name()
                    return supplementaryView
            }
        }
    }
}

//MARK: UICollectionViewDelegate

extension HeroesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let hero = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.moveToHeroDetailWith(hero: hero)
    }
}
