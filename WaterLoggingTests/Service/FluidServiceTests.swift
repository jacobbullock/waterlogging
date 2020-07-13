//
//  FluidServiceTests.swift
//  WaterLoggingTests
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import XCTest
@testable import WaterLogging

class FluidServiceTests: XCTestCase {
    
    var fluidService: FluidService = CoreDataFluidService()

    override func setUpWithError() throws {
        configurePersistentStore()
    }

    override func tearDownWithError() throws {
        clearPersistentStore()
    }

    func test_fetchAll_returnsFluidsOrderedByIndex() throws {
        let fluids = fluidService.fetchAll()
        let indecies = fluids.map { $0.index }

        XCTAssertEqual(indecies , [0,1,2,3])
    }
    
    func test_orderedFluidsHaveCorrectNames() throws {
        let fluids = fluidService.fetchAll()
        let names = fluids.map { $0.name }

        XCTAssertEqual(names,  ["Water", "Tea", "Coffee", "Juice"])
    }

}
