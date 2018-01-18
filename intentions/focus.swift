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
var focus = Focus()

class Focus: NSObject, NSCoding {
    //Mark: Properties
    
    @objc dynamic var intention = Intention() {
        didSet {
            NotificationCenter.default.post(name: focusUpdated, object: nil)
        }
    }
    var began = Date()
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("focusData")
    
    //MARK: Types
    
    struct PropertyKey {
        static let intention = "intention"
        static let began = "began"
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(intention, forKey: PropertyKey.intention)
        aCoder.encode(began, forKey: PropertyKey.began)
    }
    
    //Mark: Initialization
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        if let intention = aDecoder.decodeObject(forKey: PropertyKey.intention) as? Intention {
            self.intention = intention
        }
        
        if let began = aDecoder.decodeObject(forKey: PropertyKey.began) as? Date {
            self.began = began
        }
    }
}
