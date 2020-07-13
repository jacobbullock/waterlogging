//
//  Fluid+CoreDataProperties.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Fluid {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fluid> {
        return NSFetchRequest<Fluid>(entityName: "Fluid")
    }

    @NSManaged public var index: Int16
    @NSManaged public var name: String
    @NSManaged public var waterBase: Double
    @NSManaged public var intakes: NSSet?

}

// MARK: Generated accessors for intakes
extension Fluid {

    @objc(addIntakesObject:)
    @NSManaged public func addToIntakes(_ value: Intake)

    @objc(removeIntakesObject:)
    @NSManaged public func removeFromIntakes(_ value: Intake)

    @objc(addIntakes:)
    @NSManaged public func addToIntakes(_ values: NSSet)

    @objc(removeIntakes:)
    @NSManaged public func removeFromIntakes(_ values: NSSet)

}
