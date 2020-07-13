//
//  IntakeServiceTests.swift
//  WaterLoggingTests
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import XCTest
@testable import WaterLogging

class IntakeServiceTests: XCTestCase {
    
    var intakeService: IntakeService = CoreDataIntakeService()
    var fluidService: FluidService = CoreDataFluidService()

    override func setUp() {
        configurePersistentStore()
    }

    override func tearDownWithError() throws {
        clearPersistentStore()
    }
    
    func test_totalIntakeForToday_willCalculateComputedVolumeCorrectlyForWater() throws {
        let water = fluidService.fetchAll().first!
        intakeService.addIntakeToday(volume: 20, fluid: water)
        intakeService.addIntakeToday(volume: 20, fluid: water)
        intakeService.addIntake(volume: 20, fluid: water, on: Date().yesterday)
        
        let total = intakeService.totalIntakeForToday()
        XCTAssertEqual(Int(total), 40)
    }
    
    func test_totalIntakeForToday_willCalculateComputedVolumeCorrectlyForJuice() throws {
        let juice = fluidService.fetchAll().last!
        intakeService.addIntakeToday(volume: 30, fluid: juice)
        intakeService.addIntakeToday(volume: 20, fluid: juice)
        intakeService.addIntake(volume: 20, fluid: juice, on: Date().yesterday)
        
        let total = intakeService.totalIntakeForToday()
        let expectation = Int(50.0 * juice.waterBase)
        XCTAssertEqual(Int(total), expectation)
    }

}
