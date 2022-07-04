//
//  MarvelEndpoint.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation

struct KeyDict {
    let publicKey: String
    let privateKey: String
}

enum RequestType {
    case get
    case post
    case put
}

protocol Endpoint {
    
    var scheme: String { get }
    var baseURL: String { get }
    var port: Int? { get }
    var path: String { get }
    var method: RequestType { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    
    func createURLComponents() -> URLComponents {
        
        var components = URLComponents()
        components.host = baseURL
        components.port = port
        components.path = path
        components.queryItems = queryItems
        components.scheme = scheme
        
        return components
    }
    
    /// Method fetches public & private keys from plist file
    ///
    /// - Parameter value: Comic object
    /// - Returns: KeyDict (Struct of Private and Public keys)
    func getKeys() -> KeyDict {
        
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)!
        }
        
        if let data = keys {
            return KeyDict(publicKey: (data["publicKey"] as! String), privateKey: (data["privateKey"] as! String))
        } else {
            return KeyDict(publicKey: "", privateKey: "")
        }
    }
}
