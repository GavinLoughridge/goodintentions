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
    @IBAction func intentionPickerAction(_ value: Int) {
        print("picker item selected")
    }
    
    //
//    @IBAction func pickerSelectedItemChanged(value: Int) {
//        NSLog("list picker: \(myList[value].0) selected")
//    }
    
    // declare properties and observers
//    var intentionsDataWatch = [Intention]()
//
    var myList: [String] = [
        "testone",
        "testtwo",
        "testthree",
        "testfour"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
//        let pickerItems: [WKPickerItem] = myList.map {
//            let pickerItem = WKPickerItem()
//            pickerItem.title = $0
//            //pickerItem.caption = $0.1
//            print("added item", pickerItem.title)
//            return pickerItem
//        }
//
//        print("items are:", pickerItems)
//        print("picker is:", intentionPicker)
//
//        intentionPicker.setItems(pickerItems)

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        NSLog("test ns")
        print("test print")
        
//        let pickerItems: [WKPickerItem] = myList.map {
//            let pickerItem = WKPickerItem()
//            pickerItem.title = $0
//            //pickerItem.caption = $0.1
//            print("added item", pickerItem.title)
//            return pickerItem
//        }
//
//        print("items are:", pickerItems)
//        print("picker is:", intentionPicker)
//
        let testItem = WKPickerItem()
        testItem.title = "test pick"
        let testItem2 = WKPickerItem()
        testItem2.title = "test pick2"
        
        print("about to set items")
        intentionPicker.setItems([testItem, testItem2])
        print("just set items")
        
//        intentionPicker.setItems([
//            WKPickerItem(title: "test1"),
//            WKPickerItem(title: "test2"),
//            WKPickerItem(title: "test3"),
//            WKPickerItem(title: "test4")
//            ])
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
