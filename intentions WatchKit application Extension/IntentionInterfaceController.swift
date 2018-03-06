//
//  IntentionInterfaceController.swift
//  intentions WatchKit application Extension
//
//  Created by Gavin Loughridge on 1/21/18.
//  Copyright © 2018 Gavin Loughridge. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

var testIntentions = [
    "meditation",
    "run",
    "study"
]

class IntentionInterfaceController: WKInterfaceController {
    
    @IBOutlet var intentionsTable: WKInterfaceTable!
    
    var selected = "meditation"
    
    override func willActivate() {
        super.willActivate()
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        intentionsTable.setNumberOfRows(testIntentions.count, withRowType: "IntentionRow")
        
        for index in 0..<intentionsTable.numberOfRows {
            guard let controller = intentionsTable.rowController(at: index) as? IntentionRowController else {continue}
            
            let intention = testIntentions[index]
            
            controller.intentionName = intention
            
            if intention == selected {
                controller.isSelected = true
            } else {
                controller.isSelected = false
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let controller = intentionsTable.rowController(at: rowIndex) as? IntentionRowController else {return}
        
        let intention = testIntentions[rowIndex]
        
        if intention == selected {
            controller.isSelected = false
            selected = ""
        } else {
            for index in 0..<testIntentions.count {
                if testIntentions[index] == selected {
                    guard let selectedController = intentionsTable.rowController(at: index) as? IntentionRowController else {return}
                    selectedController.isSelected = false
                }
            }
            
            controller.isSelected = true
            selected = intention
        }
    }
}

extension IntentionInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
