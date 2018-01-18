//
//  intentionTableViewController.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/23/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit

class intentionTableViewController: UITableViewController {
    
    // MARK: Properties
    //var focus = Focus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if let savedIntentions = loadIntentions() {
            intentionsData += savedIntentions
        }
        
        if let savedFocus = loadFocus() {
            focus = savedFocus
        }
    }
    
    // MARK: View functions
    // on appearance set observers and then update the model
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self,
                                                 name: .UIApplicationDidBecomeActive,
                                                 object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)

        updateFocus()
        updateModel()
    }
    
    // on disappearance remove observers
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    // on becoming active update the model
    @objc func applicationDidBecomeActive() {
        updateFocus()
        updateModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intentionsData.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Intention view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "intentionTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? intentionTableViewCell else {
            fatalError("The dequeued cell is not an instance of intentionTableViewCell")
        }
        
        let intention = intentionsData[indexPath.row]

        cell.nameLabel.text = intention.name
        
        if intention.name == focus.intention.name {
            cell.backgroundColor = UIColor(red: 252 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 218 / 255, green: 252 / 255, blue: 241 / 255, alpha: 1)
        }
        
        cell.progressChart.chartValue = Float(intention.progressInMinutes / intention.goalInMinutes)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let intention = intentionsData[indexPath.row]
            
            updateFocus()
            
            // remove focus if nessecary
            if intention.name == focus.intention.name {
                focus.intention = Intention()
            }
            // Delete the row from the data source
            intentionsData.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            updateModel()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let intention = intentionsData[indexPath.row]

        updateFocus()
        
        if intention.name == focus.intention.name {
            focus.intention = Intention()
        } else {
            focus.intention = intention
            focus.began = Date()
        }

        updateModel()
    }
    
    // MARK: Actions
    
    @IBAction func unwindToIntentionList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController {
            // Add a new intention.
            let intention = sourceViewController.intention
            let newIndexPath = IndexPath(row: intentionsData.count, section: 0)
            
            intentionsData.append(intention)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            saveIntentions()
        }
    }
    
    // MARK: Pirvate Methods
    
    // sets the correct current position of an intention
    private func updatePosition(intention: Intention, began: Date?=nil) {
        // set variables for intention
        let lastChangedUnajustedDayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: intention.lastUpdated)
        let lastChangedDayOfWeek = (lastChangedUnajustedDayOfWeek + 5) % 7 // first day of the week is now Monday
        let lastChangedDay = Calendar.current.component(.day, from: intention.lastUpdated)
        let lastChangedMonth = Calendar.current.component(.month, from: intention.lastUpdated)
        let lastChangedYear = Calendar.current.component(.year, from: intention.lastUpdated)
        
        // set variables for current date
        let currentDate = Date()
        let currentUnajustedDayOfWeek = Calendar(identifier: .gregorian).component(.weekday, from: currentDate)
        let currentDayOfWeek = (currentUnajustedDayOfWeek + 5) % 7 // first day of the week is now Monday
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
            let beganDayOfWeek = (beganUnadjustedDayOfWeek + 5) % 7 // first day of the week is now Monday
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

    private func updateFocus() {
        // update current focus progress if one exists
        if focus.intention.name != "", let focusIntention = (intentionsData.filter{ $0.name == focus.intention.name}.first) {
            updatePosition(intention: focusIntention, began: focus.began)
            focus.intention = focusIntention
            focus.began = Date()
        }
    }
    
    private func updateModel() {
        // update intentions progress
        for i in 0..<intentionsData.count {
            updatePosition(intention: intentionsData[i])
        }
        
        saveIntentions()
        self.tableView.reloadData()
    }
    
    // save and load functions
    private func loadFocus() -> Focus? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Focus.ArchiveURL.path) as? Focus
    }
    
    private func saveIntentions() {
        NSKeyedArchiver.archiveRootObject(intentionsData, toFile: Intention.ArchiveURL.path)
    }
    
    private func loadIntentions() -> [Intention]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Intention.ArchiveURL.path) as? [Intention]
    }
}
