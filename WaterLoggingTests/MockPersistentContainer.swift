//
//  MockPersistentContainer.swift
//  WaterLoggingTests
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreData
@testable import WaterLogging

func configurePersistentStore() {
    CoreDataStack.shared.persistentContainer = mockPersistantContainer
    CoreDataStack.shared.seedData()
}

func clearPersistentStore() {
    CoreDataStack.shared.persistentContainer = nil
}

var mockPersistantContainer: NSPersistentContainer {
    let container = NSPersistentContainer(name: "WaterLogging")
    let description = NSPersistentStoreDescription()
    description.shouldAddStoreAsynchronously = false
    description.url = URL(fileURLWithPath: "/dev/null")
    container.persistentStoreDescriptions = [description]

    container.loadPersistentStores { (description, error) in
        precondition( description.type == NSSQLiteStoreType )
        if let error = error {
            fatalError("failed to create in memory container \(error)")
        }
    }
    return container
}
