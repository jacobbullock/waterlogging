//
//  GoalServiceTests.swift
//  WaterLoggingTests
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import XCTest
@testable import WaterLogging

class GoalServiceTests: XCTestCase {
    
    var goalService: GoalService = CoreDataGoalService()

    override func setUpWithError() throws {
        configurePersistentStore()
    }

    override func tearDownWithError() throws {
        clearPersistentStore()
    }
    
    func test_createGoal_newGoalHasNoEndDate() throws {
        let goal = try! goalService.createGoal(amount: 100, startDate: Date())

        XCTAssertNil(goal.endDate)
    }
    
    func test_createGoal_willFailToCreateGoalsWithADuplicateStartDate() throws {
        try! goalService.createGoal(amount: 100, startDate: Date())
        XCTAssertThrowsError(try goalService.createGoal(amount: 100, startDate: Date()))
    }
    
    func test_updateGoal_willEndAnExistingGoalIfStartDateIsNotToday() throws {
        try! goalService.createGoal(amount: 100, startDate: Date().yesterday)
        try! goalService.updateGoal(amount: 120)
        
        let yesterdayGoal = goalService.goalStarted(on: Date().yesterday)

        XCTAssert(Calendar.current.isDateInYesterday(yesterdayGoal!.endDate!))
    }

}
