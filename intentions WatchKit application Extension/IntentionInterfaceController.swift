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

class IntentionInterfaceController: WKInterfaceController {
    
    @IBOutlet var intentionsTable: WKInterfaceTable!
    
//    create local model variables
    var focus = String()
    var intentions = [String]()
    
//    activate watch session
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
//    on row selection send click data to phone app and update view and local model
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if let controller = intentionsTable.rowController(at: rowIndex) as? IntentionRowController {
            let intention = intentions[rowIndex]
            sendSelection(selection: intention)
            if intention == focus {
                focus = String()
                controller.isSelected = false
            } else {
                if let index = intentions.index(of: focus), let prevIntention = intentionsTable.rowController(at: index) as? IntentionRowController {
                    prevIntention.isSelected = false
                }
                focus = intention
                controller.isSelected = true
            }
        }
    }
    
//    request latest model from phone app and update local model on reply
    func getModel() {
        let session = WCSession.default
        if session.isReachable {
            session.sendMessage(["request":"update"], replyHandler: {
                data in
                if let focus = data["focus"] as? String {
                    self.focus = focus
                }
                if let intentions = data["intentions"] as? [String] {
                    self.intentions = intentions
                }
                self.intentionsTable.setNumberOfRows(self.intentions.count, withRowType: "IntentionRow")
                for index in 0..<self.intentionsTable.numberOfRows {
                    if let controller = self.intentionsTable.rowController(at: index) as? IntentionRowController {
                        let intention = self.intentions[index]
                        controller.intentionName = intention
                        controller.isSelected = (intention == self.focus)
                    }
                }
            }, errorHandler: { error in
                print("Error sending message",error)
            })
        }
    }
    
//    send selection data to phone app
    func sendSelection(selection: String) {
        let session = WCSession.default
        if session.isReachable {
            session.sendMessage(["clicked": selection], replyHandler: nil, errorHandler: { error in
                print("Error sending message",error)
            })
        }
    }
}

extension IntentionInterfaceController: WCSessionDelegate {
//    request latest model on session activation
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        getModel()
    }
    
//    update local model on changes to application context
    func session(_ session: WCSession,
                 didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async() {
            if let focus = applicationContext["focus"] as? String {
                self.focus = focus
            }
            if let intentions = applicationContext["intentions"] as? [String] {
                self.intentions = intentions
            }

            self.intentionsTable.setNumberOfRows(self.intentions.count, withRowType: "IntentionRow")
            for index in 0..<self.intentionsTable.numberOfRows {
                if let controller = self.intentionsTable.rowController(at: index) as? IntentionRowController {
                    let intention = self.intentions[index]
                    controller.intentionName = intention
                    controller.isSelected = (intention == self.focus)
                }
            }
        }
    }
}
