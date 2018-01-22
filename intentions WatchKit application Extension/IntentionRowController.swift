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
    
    var intentionName: String? {
        didSet {
            guard let intentionName = intentionName else {return}
            
            intentionLabel.setText(intentionName)
        }
    }
    
    var isSelected: Bool? {
        didSet {
            guard let isSelected = isSelected else {return}
            
            if isSelected {
                intentionGroup.setBackgroundColor(UIColor.blue)
            } else {
                intentionGroup.setBackgroundColor(UIColor.red)
            }
        }
    }
    
    
    
}
