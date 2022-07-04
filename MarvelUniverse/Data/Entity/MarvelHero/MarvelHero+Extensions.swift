//
//  MarvelHero+Extensions.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation

/*
    Computing imagePath from thumbnail and returning URL instance
*/

extension MarvelHero {
    
    //MARK: Computed Properties
    
    var imagePath: URL {
        let urlString = String("\(thumbnail!.path).\(thumbnail!.imageExtension)")
        return URL(string: urlString)!
    }
}

/*
    Protocol confirmance, confirming to hashable as it's necessary to use it for diffable data sources
    Cofirming to equatable as diffable data source uses equatable to check if same data is being inserted,
    and as we are inserting both data from core data and remote fetch, it can collide, so we are equating
    based on isFavorite value which will always be true only for core data entities, therefore there will
    be no collisions and both saved squad and remote fetched characters will be displayed in collection view
*/

extension MarvelHero {
    
    //MARK: Protocol Confirmance
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(isFavorite)
    }
    
    static func == (lhs: MarvelHero, rhs: MarvelHero) -> Bool {
        return lhs.id == rhs.id && lhs.isFavorite == rhs.isFavorite
    }
}
