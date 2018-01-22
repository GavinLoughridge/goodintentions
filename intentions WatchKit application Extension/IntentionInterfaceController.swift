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

    @IBOutlet var myLabel: WKInterfaceLabel!
    @IBOutlet var intentionPicker: WKInterfacePicker!
    
    var data: String? {
        didSet {
            guard let data = data else {return}
            myLabel.setText(data)
        }
    }
    
    var myList: [(String, String)] = [
        ("MEDITATE", "test a"),
        ("RUN", "test b"),
        ("TYPE", "test c"),
        ("CODE", "test d") ]
    
    var selected = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        data = "my new data"
        
        myLabel.setText("my new text")
    }
    
    override func willActivate() {
        super.willActivate()
        
        let pickerItems: [WKPickerItem] = myList.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.0
            pickerItem.caption = $0.1
            return pickerItem
        }
        intentionPicker.setItems(pickerItems)
    }
    
    @IBAction func intentionPickerChanged(_ value: Int) {
        NSLog("List Picker: \(myList[value].0) selected")
        selected = value
    }
    
    @IBAction func setFocus() {
        myLabel.setText("Focus: \(myList[selected].0)")
    }
}
