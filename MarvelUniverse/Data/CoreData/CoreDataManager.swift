//
//  CoreDataManager.swift
//  MarvelUniverse
//
//  Created by Nitesh Singh on 02/07/22.
//

import Foundation
import CoreData

struct CoreDataManager: DatabaseStorable {

    typealias PersistentContainer = NSPersistentContainer
    typealias ManagedContext = NSManagedObjectContext

    static let shared = CoreDataManager()
    static let sharedTest = CoreDataManager(isInMemoryStore: true)

    let persistentContainer: NSPersistentContainer

    var mainContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    var backgroundContext: ManagedContext {

        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.undoManager = nil

        return context
    }

    init(isInMemoryStore: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "Marvel")
        
        if isInMemoryStore {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }

        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveContext() {
        let context = mainContext

        context.performAndWait {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            context.reset()
        }
    }

    func saveContext(_ context: NSManagedObjectContext) {
        guard context != mainContext else {
            saveContext()
            return
        }

        context.performAndWait {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.saveContext(self.mainContext)
        }
    }
}
