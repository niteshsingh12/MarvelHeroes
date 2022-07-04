//
//  CryptoHashGenerator.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import CryptoKit

protocol CryptoHashable {
    static func createMD5(data: String) -> String
}

class CryptoHashGenerator: CryptoHashable {
    
    ///Creates md5 has for string and returns it (API requires hash value to be sent in query items)
    static func createMD5(data: String) -> String {
        
        let digest = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0)}.joined()
    }
}
