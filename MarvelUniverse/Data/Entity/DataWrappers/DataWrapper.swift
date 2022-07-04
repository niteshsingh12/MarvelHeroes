//
//  DataWrapper.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation

struct DataWrapper<T: Codable>: Codable {
    
    // MARK: - Variables
    
    var code: Int
    var status: String
    var copyright: String
    var data: DataContainer<T>
}
