//
//  IntakeService.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreData

protocol IntakeService {
    func totalIntakeForToday() -> Double
    func totalIntake(for date: Date) -> Double
    @discardableResult func addIntakeToday(volume: Double, fluid: Fluid) -> Intake
    @discardableResult func addIntake(volume: Double, fluid: Fluid, on date: Date) -> Intake
}

struct CoreDataIntakeService {
    // MARK: - CoreDataStack Helpers
    
    private var context: NSManagedObjectContext {
        CoreDataStack.shared.mainContext
    }
    
    private func save() {
        CoreDataStack.shared.saveContext()
    }
}

extension CoreDataIntakeService: IntakeService {
    
    func totalIntakeForToday() -> Double {
        return totalIntake(for: Date())
    }
    
    func totalIntake(for date: Date) -> Double {
        let totalIntakeKey = "totalIntake"
        
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = totalIntakeKey
        expressionDesc.expression = NSExpression(forKeyPath: "@sum.waterVolume")
        expressionDesc.expressionResultType = .doubleAttributeType;
        
        let request: NSFetchRequest<NSFetchRequestResult> = Intake.fetchRequest()
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = [expressionDesc]
        request.predicate = NSPredicate(format: "date >= %@ && date < %@",
                                        date.startOfDay as NSDate,
                                        date.tomorrow as NSDate)

        guard let result = try? CoreDataStack.shared.fetch(request),
              let dict = result.first as? [String: Double],
              let total = dict[totalIntakeKey] else {
            return 0
        }
        return total
    }
    
    @discardableResult
    func addIntakeToday(volume: Double, fluid: Fluid) -> Intake {
        return addIntake(volume: volume, fluid: fluid, on: Date())
    }
    
    @discardableResult
    func addIntake(volume: Double, fluid: Fluid, on date: Date) -> Intake {
        let intake = Intake(context: context)
        intake.date = date
        intake.fluid = fluid
        intake.volume = volume
        intake.waterVolume = volume * fluid.waterBase

        save()
        
        return intake
    }

}
