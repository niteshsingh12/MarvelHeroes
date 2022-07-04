//
//  GenericDataList.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation

/*
    For keys like comics, series etc
*/

struct GenericDataList: Codable, Identifiable {
    
    // MARK: - Properties
    
    var id: String {
        return UUID().uuidString
    }
    var available: Int = 0
    var returned: Int = 0
    var collectionURI: String?
    let items: [GenericSummary]?
}

struct GenericSummary: Codable, Identifiable {
    
    // MARK: - Properties
    
    var id: String {
        resourceURI
    }
    var resourceURI: String
    var name: String
    var role: String?
}
