//
//  NetworkService.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import Combine

protocol NetworkService {
    func fetch<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}
