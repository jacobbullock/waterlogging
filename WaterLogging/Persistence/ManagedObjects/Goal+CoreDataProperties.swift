//
//  Goal+CoreDataProperties.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var amount: Double
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date?

}
