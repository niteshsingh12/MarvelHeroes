//
//  MarvelHeroEntity+Extension.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation

/*
    Encoding and decoding MarvelHero to and from PersistentContainer
*/

extension MarvelHeroEntity {

    // MARK: - Encode
    
    func encode(entity: MarvelHero) {
        self.id = String(entity.id)
        self.name = entity.name
        self.characterDescription = entity.description
        self.isFavorite = entity.isFavorite
        self.imagePath = entity.thumbnail!.path
        self.imageExtension = entity.thumbnail!.imageExtension
        self.isFavorite = true
    }

    // MARK: - Decode
    
    func decode() -> MarvelHero {
        
        var hero = MarvelHero(id: Int(self.id!)!, name: self.name!, description: self.characterDescription, isFavorite: self.isFavorite)
        hero.thumbnail = HeroImage(path: self.imagePath!, imageExtension: self.imageExtension!)
        hero.isFavorite = true
        return hero
    }
}
