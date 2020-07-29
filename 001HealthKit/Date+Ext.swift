//
//  Date+Ext.swift
//  001HealthKit
//
//  Created by Deepak Reddy on 29/07/20.
//  Copyright © 2020 Deepak Reddy. All rights reserved.
//

import Foundation

extension Date{
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}
