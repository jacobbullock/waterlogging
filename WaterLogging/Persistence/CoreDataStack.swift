//
//  CoreDataStack.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreData

protocol Seedable {
    func seedData(completion: ((Bool) -> Void)?)
}

class CoreDataStack {
    static let shared = CoreDataStack()

    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var persistentContainer: NSPersistentContainer!
    
    // MARK: - Fetch

    func fetch<T: NSFetchRequestResult>(_ request: NSFetchRequest<T>) throws -> [T] {
        return try mainContext.fetch(request)
    }
    
    // MARK: - Saving

    func saveContext () {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
        
    // MARK: - Clearing CoreData objects
    
    public func clearAllCoreData() {
        let entities = self.persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach {
            self.clearDeepObject(for: $0)
        }
    }

    public func clearDeepObject(for entity: String) {
        let context = mainContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error removing data for entity: \(entity)")
        }
    }
}
