//
//  IntentionInterfaceController.swift
//  intentions WatchKit application Extension
//
//  Created by Gavin Loughridge on 1/21/18.
//  Copyright © 2018 Gavin Loughridge. All rights reserved.
//

import WatchKit
import Foundation

class IntentionInterfaceController: WKInterfaceController {

    @IBOutlet var intentionsTable: WKInterfaceTable!
    
    var testIntentions = [
        "meditation",
        "run",
        "study"
    ]
    
    var selected = "meditation"
    
    override func willActivate() {
        super.willActivate()
        
        let tempFocus = focus
        
        print("temp focus is:", tempFocus)
        print("temp focus intention is:", tempFocus.intention)
        print("temp focus intention name is:", tempFocus.intention.name)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        intentionsTable.setNumberOfRows(intentionsData.count, withRowType: "IntentionRow")
        
        for index in 0..<intentionsTable.numberOfRows {
            guard let controller = intentionsTable.rowController(at: index) as? IntentionRowController else {continue}
            
            let intention = intentionsData[index]
            
            controller.intentionName = intention.name
            
            if intention.name == focus.intention.name {
                controller.isSelected = true
            } else {
                controller.isSelected = false
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let controller = intentionsTable.rowController(at: rowIndex) as? IntentionRowController else {return}
        
        let intention = intentionsData[rowIndex]
        
        if intention.name == focus.intention.name {
            controller.isSelected = false
            selected = ""
        } else {
            for index in 0..<intentionsData.count {
                if intentionsData[index].name == focus.intention.name {
                    guard let selectedController = intentionsTable.rowController(at: index) as? IntentionRowController else {return}
                    selectedController.isSelected = false
                }
            }
            
            controller.isSelected = true
            focus.intention = intention
            focus.began = Date()
        }
    }
}
