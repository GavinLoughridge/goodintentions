//
//  IntentionRowController.swift
//  intentions WatchKit application Extension
//
//  Created by Gavin Loughridge on 1/21/18.
//  Copyright © 2018 Gavin Loughridge. All rights reserved.
//

import WatchKit

class IntentionRowController: NSObject {

    @IBOutlet var intentionLabel: WKInterfaceLabel!
    @IBOutlet var intentionGroup: WKInterfaceGroup!
    var active = UIColor(red: 4 / 255, green: 222 / 255, blue: 113 / 255, alpha: 1)
    var inactive = UIColor(red: 35 / 255, green: 35 / 255, blue: 35 / 255, alpha: 1)
    
    var intentionName = "" {
        didSet {
            intentionLabel.setText(intentionName)
        }
    }
    
    var isSelected = false {
        didSet {
            if isSelected {
                intentionGroup.setBackgroundColor(active)
            } else {
                intentionGroup.setBackgroundColor(inactive)
            }
        }
    }
    
    
    
}
