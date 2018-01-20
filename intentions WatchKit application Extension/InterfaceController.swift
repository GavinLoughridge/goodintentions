//
//  InterfaceController.swift
//  intentions WatchKit application Extension
//
//  Created by Gavin Loughridge on 1/20/18.
//  Copyright © 2018 Gavin Loughridge. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    
    @IBOutlet var focusLabel: WKInterfaceLabel!
    @IBOutlet var intentionPicker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
