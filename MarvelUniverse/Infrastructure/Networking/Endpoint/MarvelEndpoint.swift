//
//  MarvelEndpoint.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import CryptoKit

enum MarvelEndpoint: Endpoint {
    
    // MARK: - Endpoints
    
    case heroes(request: HeroRequest)
    
    // MARK: - URL Properties
    
    var scheme: String {
        switch self {
        default: return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        default: return "gateway.marvel.com"
        }
    }
    
    var port: Int? {
        return 443
    }
    
    var path: String {
        switch self {
        case .heroes: return "/v1/public/characters"
        }
    }
    
    var method: RequestType {
        switch self {
        default: return .get
        }
    }
    
    var queryItems: [URLQueryItem] {
        
        let keys = getKeys()
        let publicKey = keys.publicKey
        let privateKey = keys.privateKey
        
        let ts = NSDate().timeIntervalSince1970.description
        let hash = CryptoHashGenerator.createMD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        var queryItems = [URLQueryItem(name: "apikey", value: publicKey),
                          URLQueryItem(name: "hash", value: hash),
                          URLQueryItem(name: "ts", value: ts)]
        
        switch self {
        case .heroes(let request):
            queryItems.append(URLQueryItem(name: "limit", value: String(request.limit)))
            queryItems.append(URLQueryItem(name: "offset", value: String(request.offset)))
            return queryItems
        }
    }
}
