//
//  focus.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/24/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit
import os.log

var focusUpdated = Notification.Name("focusUpdated")
var focus: Focus! {
    didSet {
        NotificationCenter.default.post(name: focusUpdated, object: nil)
    }
}

class Focus: NSObject, NSCoding {
    
    //Mark: Properties
    
    var intention: Intention
    var began: Date
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("focusData")
    
    //MARK: Types
    
    struct PropertyKey {
        static let intention = "intention"
        static let began = "began"
    }
    
    //Mark: Initialization
    
    init?(intention: Intention, began: Date) {
        // Initialize stored properties
        self.intention = intention
        self.began = began
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(intention, forKey: PropertyKey.intention)
        aCoder.encode(began, forKey: PropertyKey.began)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let intention = aDecoder.decodeObject(forKey: PropertyKey.intention) as? Intention else {
            os_log("Unable to decode the intention for a focus object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let began = aDecoder.decodeObject(forKey: PropertyKey.began) as? Date else {
            os_log("Unable to decode the date for a focus object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(intention: intention, began: began)
    }
}
