//
//  HeroImage.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation

/*
    For key thumbnail in character entity, contains path and image extension
*/

struct HeroImage: Codable, Identifiable {
    
    // MARK: - Properties
    
    var id: String {
        return path
    }
    var path: String
    var imageExtension: String
    
    enum CodingKeys: String, CodingKey {
        case imageExtension = "extension", path
    }
}
