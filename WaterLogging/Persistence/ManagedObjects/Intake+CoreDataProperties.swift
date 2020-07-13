//
//  Intake+CoreDataProperties.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Intake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Intake> {
        return NSFetchRequest<Intake>(entityName: "Intake")
    }

    @NSManaged public var volume: Double
    @NSManaged public var waterVolume: Double
    @NSManaged public var date: Date
    @NSManaged public var fluid: Fluid

}
