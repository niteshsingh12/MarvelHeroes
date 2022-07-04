//
//  CacheServiceTests.swift
//  MarvelUniverseTests
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation
import XCTest
@testable import MarvelUniverse

class CacheServiceTests: XCTestCase {
    
    func test_imageSaveAndFetch() {
        
        guard let image = UIImage(named: "logo_marvel") else {
            XCTFail("Failed to load image")
            return
        }
        CacheService.shared.save(image: image, forKey: "logo_marvel")
        
        let fetchedImg = CacheService.shared.fetch(forKey: "logo_marvel")
        XCTAssertNotNil(fetchedImg)
    }
}
