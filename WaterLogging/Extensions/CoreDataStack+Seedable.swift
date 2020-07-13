//
//  CoreDataStack+Seedable.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension CoreDataStack: Seedable {
    func seedData(completion: ((Bool) -> Void)? = nil) {
        let context = mainContext
        
        let water = Fluid(context: context)
        water.name = "Water"
        water.index = 0
        water.waterBase = 1

        let tea = Fluid(context: context)
        tea.name = "Tea"
        tea.index = 1
        tea.waterBase = 1

        let coffee = Fluid(context: context)
        coffee.name = "Coffee"
        coffee.index = 2
        coffee.waterBase = 0.98

        let juice = Fluid(context: context)
        juice.name = "Juice"
        juice.index = 3
        juice.waterBase = 0.85

        saveContext()
        
        completion?(true)
    }
}
