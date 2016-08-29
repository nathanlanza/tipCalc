//
//  Lets.swift
//  tipCalc
//
//  Created by Nathan Lanza on 8/29/16.
//  Copyright © 2016 Nathan Lanza. All rights reserved.
//

import Foundation

struct Lets {
    static var df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy HH:mm"
        return df
    }()
    static var defaults = UserDefaults.standard
    static var amountOfDaysToKeep: Double {
        get { return defaults.object(forKey: "daysToKeep") as? Double ?? 10 }
        set { defaults.set(newValue, forKey: "daysToKeep") }
    }
    
    static var tipPercentageString: String { return "(\(Int(tipPercentage * 100))%)" }
    static var tipPercentage: Double {
        get { return defaults.object(forKey: "tipPercentage") as? Double ?? 0.20 }
        set { defaults.set(newValue, forKey: "tipPercentage") }
    }
}
