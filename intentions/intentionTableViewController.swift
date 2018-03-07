//
//  IntentionTableViewController.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/23/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit

class IntentionTableViewController: UITableViewController {
    
//    set up local instance of model struct
    var model = IntentionModel.Model()
    
    // MARK: Properties
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: View functions
    // on appearance set observers and then request updated model
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self,
                                                 name: .UIApplicationDidBecomeActive,
                                                 object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: IntentionModel.sharedInstance.updatedNotification,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTable(_:)),
                                               name: IntentionModel.sharedInstance.updatedNotification,
                                               object: nil)
        IntentionModel.sharedInstance.requestUpdate()
    }
    
    // on disappearance remove observers
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: IntentionModel.sharedInstance.updatedNotification,
                                                  object: nil)
    }
    
    // on becoming active request updated model
    @objc func applicationDidBecomeActive() {
        IntentionModel.sharedInstance.requestUpdate()
    }
    
//    set local model to match latest shared model and reload the table
    @objc func updateTable(_ notification: NSNotification) {
        if let updatedModel = notification.userInfo?["model"] as? IntentionModel.Model {
            model = updatedModel
            self.tableView.reloadData()
        }
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
        return model.intentions.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Intention view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "IntentionTableViewCell"
        
//        ensure dequeued cell is an instance of IntentionTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? IntentionTableViewCell else {
            fatalError("could not dequeue cell as IntentionTableViewCell")
        }
        
//        set cell data to coresponding intention data
        let intention = model.intentions[indexPath.row]
        cell.nameLabel.text = intention.name
        cell.progressChart.chartValue = Float(intention.progressInMinutes / intention.goalInMinutes)
//        set intention color to match focus state
        if intention.name == model.focus.intention.name {
            cell.backgroundColor = UIColor(red: 252 / 255, green: 239 / 255, blue: 239 / 255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 218 / 255, green: 252 / 255, blue: 241 / 255, alpha: 1)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

//    delete an intention on swipe delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let intention = model.intentions[indexPath.row]
            model.intentions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            IntentionModel.sharedInstance.deleteIntention(oldIntention: intention, index: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
//    on row select update coresponding intention
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let intention = model.intentions[indexPath.row]
        IntentionModel.sharedInstance.setFocus(intention: intention)
    }
}
