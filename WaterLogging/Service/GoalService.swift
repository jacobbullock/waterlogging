//
//  GoalService.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreData

protocol GoalService {
    var currentGoal: Goal? { get }
    func endGoal(_ goal: Goal, on date: Date)
    func goalStarted(on date: Date) -> Goal?
    @discardableResult func updateGoal(amount: Double) throws -> Goal
    @discardableResult func createGoal(amount: Double, startDate: Date) throws -> Goal
}

struct CoreDataGoalService {
    // MARK: - CoreDataStack Helpers
    
    private var context: NSManagedObjectContext {
        CoreDataStack.shared.mainContext
    }
    
    private func save() {
        CoreDataStack.shared.saveContext()
    }
}

extension CoreDataGoalService: GoalService {
 
    enum Error: Swift.Error {
        case duplicateStartDate
    }
    
    var currentGoal: Goal? {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "endDate == nil")
        
        guard let goals = try? CoreDataStack.shared.fetch(request) else {
            return nil
        }
        
        return goals.first
    }
    
    func goalStarted(on date: Date) -> Goal? {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "startDate >= %@ && startDate < %@",
                                        date.startOfDay as NSDate,
                                        date.tomorrow as NSDate)
        
        guard let goals = try? CoreDataStack.shared.fetch(request) else {
            return nil
        }

        return goals.first
    }
    
    @discardableResult
    func createGoal(amount: Double, startDate: Date = Date()) throws -> Goal {
        guard goalStarted(on: startDate) == nil else {
            throw Error.duplicateStartDate
        }
        
        if let currentGoal = self.currentGoal {
            endGoal(currentGoal)
        }
        
        let today = Calendar.current.startOfDay(for: startDate)

        let goal = Goal(context: context)
        goal.startDate = today
        goal.amount = amount
        
        save()
        
        return goal
    }
    
    @discardableResult
    func updateGoal(amount: Double) throws -> Goal {
        guard let goal = currentGoal else {
            return try createGoal(amount: amount)
        }
        
        if Calendar.current.isDateInToday(goal.startDate) {
            goal.amount = amount
            save()
            return goal
        } else {
            return try createGoal(amount: amount)
        }
    }
    
    func endGoal(_ goal: Goal, on date: Date = Date().yesterday) {
        goal.endDate = date
        save()
    }
}
