//
//  IntentionController.swift
//  intentions
//
//  Created by Gavin Loughridge on 3/5/18.
//  Copyright © 2018 Gavin Loughridge. All rights reserved.
//

import Foundation

fileprivate let modelController = IntentionModel

class IntentionModel {
    struct Focus {
        var intention = Intention()
        var isSet = false
        var began = Date()
    }
    
    struct Model {
        var focus = Focus()
        var intentions = []
    }
    
    var model = Model()
    
    var updatedNotification = Notification.Name("modelUpdated")
    
    class var sharedInstance : IntentionModel {
        return modelController
    }
    
    func deleteIntention(oldIntention: Intention, index: Int) {
        if (oldIntention.name == model.focus.intention.name) {
            model.focus = Focus()
        }
        model.intentions.remove(at: index)
        updateIntentions()
        notifyViews()
    }
    
    func addIntention(newIntention: Intention) {
        model.intentions.append(newIntention)
        saveModel()
        updateIntentions()
        notifyViews()
    }
    
    func setFocus(intention: Intention) {
        updateIntentions()
        
        if intention.name == model.focus.name {
            model.focus = Focus()
        } else {
            model.focus.intention = intention
            model.focus.began = Date()
            model.focus.isSet = true
        }
        
        notifyViews()
    }
    
    func requestUpdate() {
        updateIntentions()
        notifyViews()
    }
    
    // sets the correct current position of an intention
    private func updatePosition(intention: Intention, began: Date?=nil) {
        // set variables for intention
        let lastChangedUnajustedDayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: intention.lastUpdated)
        // set first day of the week to Monday
        let lastChangedDayOfWeek = (lastChangedUnajustedDayOfWeek + 5) % 7
        let lastChangedDay = Calendar.current.component(.day, from: intention.lastUpdated)
        let lastChangedMonth = Calendar.current.component(.month, from: intention.lastUpdated)
        let lastChangedYear = Calendar.current.component(.year, from: intention.lastUpdated)
        
        // set variables for current date
        let currentDate = Date()
        let currentUnajustedDayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: currentDate)
        // set first day of the week to Monday
        let currentDayOfWeek = (currentUnajustedDayOfWeek + 5) % 7
        let currentDay = Calendar.current.component(.day, from: currentDate)
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        let currentYear = Calendar.current.component(.year, from: currentDate)
        let currentHour = Calendar.current.component(.hour, from: currentDate)
        let currentMin = Calendar.current.component(.minute, from: currentDate)
        let currentSec = Calendar.current.component(.second, from: currentDate)
        
        // should reset daily intentions at midnight
        if intention.progressResetPeriod == "day" && (lastChangedDay != currentDay || lastChangedMonth != currentMonth || lastChangedYear != currentYear) {
            intention.progressInMinutes = Float(0)
        }
        
        // should reset weekly intentions at midnight on saturday
        if intention.progressResetPeriod == "week" && (lastChangedDayOfWeek > currentDayOfWeek ||  currentDate.timeIntervalSince(intention.lastUpdated) > 604800) {
            intention.progressInMinutes = Float(0)
        }
        
        // should update position if it is being changed
        if let beganDate = began {
            let beganUnadjustedDayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: beganDate)
            // set first day of the week to Monday
            let beganDayOfWeek = (beganUnadjustedDayOfWeek + 5) % 7
            let beganDay = Calendar.current.component(.day, from: beganDate)
            let beganMonth = Calendar.current.component(.month, from: beganDate)
            let beganYear = Calendar.current.component(.year, from: beganDate)
            
            if intention.progressResetPeriod == "day" && (beganDay != currentDay || beganMonth != currentMonth || beganYear != currentYear) {
                // should truncate beggining of daily intentions at midnight
                intention.progressInMinutes += Float(currentHour * 60 + currentMin + currentSec / 60)
            } else if intention.progressResetPeriod == "week" && (beganDayOfWeek > currentDayOfWeek ||  currentDate.timeIntervalSince(beganDate) > 604800) {
                // should truncate beggining of weekly intentions at midnight on saturday
                intention.progressInMinutes += Float(currentDayOfWeek * 24 * 60 + currentHour * 60 + currentMin + currentSec / 60)
            } else {
                // otherwise add untruncated time interval
                intention.progressInMinutes += Float(currentDate.timeIntervalSince(beganDate) / 60)
            }
        }
        
        intention.lastUpdated = currentDate
        
        return
    }
    
    private func updateIntentions() {
        for intention in model.intentions {
            if (intention.name == model.focus.intention.name) {
                updatePosition(intention: model.focus.intention, began: model.focus.began)
                model.focus.began = Date()
                intention = model.focus.intention
            } else {
                updatePosition(intention: intention)
            }
        }
    }
    
    private func notifyViews() {
        NotificationCenter.default.post(name: modelUpdated, object: nil, userInfo: ["model": model])
    }
    
    private func saveModel() {
        NSKeyedArchiver.archiveRootObject(model, toFile: Intention.ArchiveURL.path)
    }
    
    private func loadModel() {
        if let savedModel = NSKeyedUnarchiver.unarchiveObject(withFile: Intention.ArchiveURL.path) as? IntentionModel.Model {
            model = savedModel
        }
    }
}
