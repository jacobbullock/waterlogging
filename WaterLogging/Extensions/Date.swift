//
//  Date.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    }
    
    var yesterday: Date {
        Calendar.current.date(byAdding: .second, value: -1, to: startOfDay)!
    }
}
