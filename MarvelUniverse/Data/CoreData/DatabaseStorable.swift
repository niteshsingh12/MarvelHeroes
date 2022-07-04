//
//  DatabaseStorable.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 03/07/22.
//

import Foundation

protocol DatabaseStorable {
    associatedtype PersistentContainer
    associatedtype ManagedContext

    var persistentContainer: PersistentContainer { get }
    var mainContext: ManagedContext { get }
    var backgroundContext: ManagedContext { get }

    func saveContext()
    func saveContext(_ context: ManagedContext)

    init(isInMemoryStore: Bool)
}
