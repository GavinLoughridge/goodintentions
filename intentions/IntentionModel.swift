//
//  IntentionModel.swift
//  intentions
//
//  Created by Gavin Loughridge on 3/5/18.
//  Copyright © 2018 Gavin Loughridge. All rights reserved.
//

import Foundation

// create shared singleton instance of IntentionModel
fileprivate let modelController = IntentionModel()

class IntentionModel {
//    setup and create data model
    struct Model {
        var focus = Focus()
        var intentions = [Intention]()
    }
    var model = Model()
    
    var updatedNotification = Notification.Name("modelUpdated")
    
//    make shared singleton instance available globally
    class var sharedInstance : IntentionModel {
        return modelController
    }
    
//    remove an intention at a given index
    func deleteIntention(oldIntention: Intention, index: Int) {
        updateIntentions()
        
//        remove focus if nessecary
        if (oldIntention.name == model.focus.intention.name) {
            model.focus = Focus()
        }

        model.intentions.remove(at: index)
        saveModel()
        notifyViews()
    }
    
//    add a new intention
    func addIntention(newIntention: Intention) {
        updateIntentions()
        model.intentions.append(newIntention)
        saveModel()
        notifyViews()
    }
    
//    update current focus
    func setFocus(intention: Intention) {
        updateIntentions()
        
//        set or remove focus
        if intention.name == model.focus.intention.name {
            model.focus = Focus()
        } else {
            model.focus.intention = intention
            model.focus.began = Date()
            model.focus.isSet = true
        }
        
        saveModel()
        notifyViews()
    }
    
//    update model and notify views on request
    func requestUpdate() {
        updateIntentions()
        notifyViews()
    }
    
    // set the correct current position of an intention
    private func updatePosition(intention: Intention, began: Date?=nil) {
        // set variables for intention
        let lastChangedDay = Calendar.current.component(.day, from: intention.lastUpdated)
        let lastChangedMonth = Calendar.current.component(.month, from: intention.lastUpdated)
        let lastChangedYear = Calendar.current.component(.year, from: intention.lastUpdated)
        // set first day of the week to Monday
        let lastChangedUnajustedDayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: intention.lastUpdated)
        let lastChangedDayOfWeek = (lastChangedUnajustedDayOfWeek + 5) % 7
        
        // set variables for current date
        let currentDate = Date()
        let currentDay = Calendar.current.component(.day, from: currentDate)
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        let currentYear = Calendar.current.component(.year, from: currentDate)
        let currentHour = Calendar.current.component(.hour, from: currentDate)
        let currentMin = Calendar.current.component(.minute, from: currentDate)
        let currentSec = Calendar.current.component(.second, from: currentDate)
        // set first day of the week to Monday
        let currentUnajustedDayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: currentDate)
        let currentDayOfWeek = (currentUnajustedDayOfWeek + 5) % 7
        
        // reset daily intentions at midnight
        if intention.progressResetPeriod == "day" && (lastChangedDay != currentDay || lastChangedMonth != currentMonth || lastChangedYear != currentYear) {
            intention.progressInMinutes = Float(0)
        }
        
        // reset weekly intentions at midnight on sunday
        if intention.progressResetPeriod == "week" && (lastChangedDayOfWeek > currentDayOfWeek ||  currentDate.timeIntervalSince(intention.lastUpdated) > 604800) {
            intention.progressInMinutes = Float(0)
        }
        
        // update intention progress if necessary
        if let beganDate = began {
            let beganDay = Calendar.current.component(.day, from: beganDate)
            let beganMonth = Calendar.current.component(.month, from: beganDate)
            let beganYear = Calendar.current.component(.year, from: beganDate)
            // set first day of the week to Monday
            let beganUnadjustedDayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: beganDate)
            let beganDayOfWeek = (beganUnadjustedDayOfWeek + 5) % 7
            
            if intention.progressResetPeriod == "day" && (beganDay != currentDay || beganMonth != currentMonth || beganYear != currentYear) {
                // should truncate beggining of daily intentions at midnight
                intention.progressInMinutes += Float(currentHour * 60 + currentMin + currentSec / 60)
            } else if intention.progressResetPeriod == "week" && (beganDayOfWeek > currentDayOfWeek ||  currentDate.timeIntervalSince(beganDate) > 604800) {
                // should truncate beggining of weekly intentions at midnight on sunday
                intention.progressInMinutes += Float(currentDayOfWeek * 24 * 60 + currentHour * 60 + currentMin + currentSec / 60)
            } else {
                // otherwise add untruncated time interval
                intention.progressInMinutes += Float(currentDate.timeIntervalSince(beganDate) / 60)
            }
        }
        
        intention.lastUpdated = currentDate
        
        return
    }
    
//    update progress for all intentions
    private func updateIntentions() {
        for intention in model.intentions {
            if (intention.name == model.focus.intention.name) {
                updatePosition(intention: intention, began: model.focus.began)
                model.focus.began = Date()
                model.focus.intention = intention
            } else {
                updatePosition(intention: intention)
            }
        }
    }
    
//    notify views that model has changed
    private func notifyViews() {
        NotificationCenter.default.post(name: updatedNotification, object: nil, userInfo: ["model": model])
    }
    
//    save model to nsuserdefaults
    private func saveModel() {
        NSKeyedArchiver.archiveRootObject(model.focus, toFile: Focus.ArchiveURL.path)
        NSKeyedArchiver.archiveRootObject(model.intentions, toFile: Intention.ArchiveURL.path)
    }
    
//    attempt to load model from nsuserdefaults
    func loadModel() {
        if let savedIntentions = NSKeyedUnarchiver.unarchiveObject(withFile: Intention.ArchiveURL.path) as? [Intention], let savedFocus = NSKeyedUnarchiver.unarchiveObject(withFile: Focus.ArchiveURL.path) as? Focus {
            model.intentions = savedIntentions
            model.focus = savedFocus
        }
    }
}
