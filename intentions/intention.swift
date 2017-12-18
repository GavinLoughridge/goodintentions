//
//  intention.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/23/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit
import os.log

var intentionsData = [Intention]()

enum Unit: String {
    case day
    case week
}

class Intention: NSObject, NSCoding {
    
    //Mark: Properties
    
    var name = ""
    var progressResetPeriod = ""
    var goalInMinutes: Float = 0
    var displayHours = false
    
    var goalConverted: Float {
        get {
            return (displayHours ? goalInMinutes / 60.0 : goalInMinutes)
        }
    }
    
    var goalUnit: String {
        get {
            return (displayHours ? " HRS" : " MIN")
        }
    }
    
    var progressInMinutes: Float = 0
    
    var progressConverted: Float {
        get {
            return (displayHours ? progressInMinutes / 60.0 : progressInMinutes)
        }
    }
    
    var lastUpdated = Date()
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("intentionsData")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let progressResetPeriod = "progressResetPeriod"
        static let goalInMinutes = "goalInMinutes"
        static let displayHours = "displayHours"
        static let progressInMinutes = "progressInMinutes"
        static let lastUpdated = "lastUpdated"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(progressResetPeriod, forKey: PropertyKey.progressResetPeriod)
        aCoder.encode(goalInMinutes, forKey: PropertyKey.goalInMinutes)
        aCoder.encode(displayHours, forKey: PropertyKey.displayHours)
        aCoder.encode(progressInMinutes, forKey: PropertyKey.progressInMinutes)
        aCoder.encode(lastUpdated, forKey: PropertyKey.lastUpdated)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        if let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String {
            self.name = name
        }
        
        if let progressResetPeriod = aDecoder.decodeObject(forKey: PropertyKey.progressResetPeriod) as? String {
            self.progressResetPeriod = progressResetPeriod
        }
        
        self.goalInMinutes = aDecoder.decodeFloat(forKey: PropertyKey.goalInMinutes) as Float
        
        self.displayHours = aDecoder.decodeBool(forKey: PropertyKey.displayHours) as Bool
        
        self.progressInMinutes = aDecoder.decodeFloat(forKey: PropertyKey.progressInMinutes) as Float
        
        if let lastUpdated = aDecoder.decodeObject(forKey: PropertyKey.lastUpdated) as? Date {
            self.lastUpdated = lastUpdated
        }
    }
}

//MARK: Validator

extension Intention {
    
    class Validator {
        func validate(intention: Intention) throws {
            guard intention.name.count > 0 else {
                throw Error.reason("Try giving your intention a name first.")
            }
            
            guard intention.goalInMinutes > 0 else {
                throw Error.reason("Try setting an amount of time to focus on your intention.")
            }
            
            if intention.progressResetPeriod == "day" {
                if intention.goalInMinutes > 24 * 60 {
                    throw Error.reason("Sorry, there isn't that much time in a day.")
                }
            } else if intention.progressResetPeriod == "week" {
                if intention.goalInMinutes > 7 * 24 * 60 {
                    throw Error.reason("Sorry, there isn't that much time in a week.")
                }
            }
        }
    }
}

enum Error: LocalizedError {
    
    case reason(String)
    
    var errorDescription: String? {
        switch self {
        case .reason(let value):
            return value
        }
    }
}
