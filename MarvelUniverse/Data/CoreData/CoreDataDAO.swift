//
//  CoreDataDAO.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 02/07/22.
//

import Foundation
import CoreData

protocol DatabaseDAO {

    associatedtype Entity
    associatedtype Storage

    var storage: Storage { get }
    init(storage: Storage)

    func add(_ entity: Entity) async -> Entity
    func get() async throws -> [Entity]
    func delete(_ entity: Entity) async throws -> Bool
    func checkIfEntityAdded(_ entity: Entity) async throws -> Bool
}

enum CoreDataError: Error {
    case defaultError(String)
    case inconsistentState
}

protocol EntityIdentifiable {
    var id: Int { get set }
}

class CoreDataDAO<Entity: EntityIdentifiable, ManagedObject: NSManagedObject>: DatabaseDAO {
    
    typealias Storage = CoreDataManager
    typealias FetchRequest = NSFetchRequest<ManagedObject>

    var storage: Storage

    required init(storage: Storage = CoreDataManager.shared) {
        self.storage = storage
    }

    /// Creates crud request and create//delete entity
    func createCRUDRequest(_ entity: Entity) throws -> FetchRequest {
        let request = ManagedObject.fetchRequest() as! FetchRequest
        request.predicate = NSPredicate(format: "id = %@", String(entity.id))
        return request
    }

    /// Creates get request and fetches all associated entities
    func createGetAllRequest() -> FetchRequest {
        let request: FetchRequest = ManagedObject.fetchRequest() as! FetchRequest

        if let sortDescriptors = self.sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        return request
    }

    func add(_ entity: Entity) async -> Entity {

        let backgroundContext = storage.backgroundContext

        var updatedEntity: Entity!
        await backgroundContext.perform {

            let results = try? backgroundContext.fetch(self.createCRUDRequest(entity))

            var coreDataObject: ManagedObject

            if results?.count == 0 {
                coreDataObject = ManagedObject(context: backgroundContext)
            } else {
                coreDataObject = results!.first!
            }
            self.encode(entity: entity, into: &coreDataObject)
            self.storage.saveContext(backgroundContext)
            updatedEntity = self.decode(object: coreDataObject)
        }
        return updatedEntity
    }

    func get() async throws -> [Entity] {

        let backgroundContext = storage.backgroundContext
        var result: [Entity]!

        try await backgroundContext.perform {

            do {
                result = try backgroundContext.fetch(self.createGetAllRequest()).map {
                    self.decode(object: $0)
                }
            } catch {
                throw CoreDataError.defaultError("Data Could Not Be Read")
            }
        }
        return result
    }

    func delete(_ entity: Entity) async throws -> Bool {
        
        let backgroundContext = storage.backgroundContext
        try await backgroundContext.perform {
            
            let result = try backgroundContext.fetch(self.createCRUDRequest(entity))
            
            if let object = result.last {
                guard result.count == 1 else {
                    throw CoreDataError.inconsistentState
                }
                backgroundContext.delete(object)
                self.storage.saveContext(backgroundContext)
            } else {
                throw CoreDataError.defaultError("Entity Could Not Be Read")
            }
        }
        return true
    }
    
    func checkIfEntityAdded(_ entity: Entity) async throws -> Bool {
        
        let backgroundContext = storage.backgroundContext
        var returnValue = false
        
        try await backgroundContext.perform {
            
            let result = try backgroundContext.fetch(self.createCRUDRequest(entity))
            
            if let _ = result.first {
                returnValue = true
            } else {
                throw CoreDataError.defaultError("Entity Could Not Be Read")
            }
        }
        return returnValue
    }

    // MARK: - OVERRIDABLE
    var sortDescriptors: [NSSortDescriptor]? {
        return nil
    }

    func encode(entity: Entity, into object: inout ManagedObject) {}

    func decode(object: ManagedObject) -> Entity {
        fatalError("Decoding error")
    }
}
