//
//  FluidService.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreData

protocol FluidService {
    func fetchAll() -> [Fluid]
}

struct CoreDataFluidService: FluidService {    
    func fetchAll() -> [Fluid] {
        let request: NSFetchRequest<Fluid> = Fluid.fetchRequest()
        let sortIndexAscending = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortIndexAscending]
        let result = try? CoreDataStack.shared.fetch(request)
        return result ?? []
    }
}
