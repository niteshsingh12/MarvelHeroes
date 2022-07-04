//
//  DataContainer.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation

struct DataContainer<T: Codable>: Codable {
    
    // MARK: - Variables
    
    var offset: Int
    var limit: Int
    var total: Int
    var count: Int
    var results: T
}
