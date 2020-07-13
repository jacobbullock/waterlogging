//
//  UserDefaults.swift
//  WaterLogging
//
//  Created by Jacob Bullock on 7/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension UserDefaults {

    struct Key {
        static let dataStoreWasSeeded = "dataStoreWasSeeded"
    }
    
    static var dataStoreWasSeeded: Bool {
        set { UserDefaults.standard.set(newValue, forKey: Key.dataStoreWasSeeded) }
        get { UserDefaults.standard.bool(forKey: Key.dataStoreWasSeeded) }
    }

}
