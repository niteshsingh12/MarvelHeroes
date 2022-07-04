//
//  MarvelHero.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation

struct MarvelHero: EntityIdentifiable, Codable, Identifiable, Hashable {
    
    // MARK: - Properties
    
    var id: Int
    var name: String
    var description: String?
    var thumbnail: HeroImage?
    var comics: GenericDataList?
    var isFavorite: Bool = false
    
    public enum CodingKeys: CodingKey {
        case id, name, description, thumbnail, comics
    }
}
