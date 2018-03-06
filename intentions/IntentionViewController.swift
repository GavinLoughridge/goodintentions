//
//  IntentionViewController.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/26/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit
import WatchConnectivity

class IntentionViewController: UIViewController {
    
    // MARK: properties

    @IBOutlet weak var indicatorUnfocused: UILabel!
    @IBOutlet weak var indicatorFocused: UIView!
    @IBOutlet weak var indicatorName: UILabel!
    @IBOutlet weak var indicatorGoalTime: UILabel!
    @IBOutlet weak var indicatorProgressTime: UILabel!
    @IBOutlet weak var indicatorProgressPercent: UILabel!
    @IBOutlet weak var indicatorProgressChart: ProgressChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: IntentionModel.sharedInstance.updatedNotification,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateIndicator(_:)),
                                               name: IntentionModel.sharedInstance.updatedNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: IntentionModel.sharedInstance.updatedNotification,
                                                  object: nil)
    }
    
    // MARK: public functions
    
    @objc func updateIndicator(_ notification: NSNotification) {
        if let model = notification.userInfo?["model"] as? IntentionModel.Model {
            if (model.focus.isSet) {
                updateFocusIndicator(intention: model.focus.intention)
                indicatorUnfocused.alpha = 0
                indicatorFocused.alpha = 1
            } else {
                indicatorUnfocused.alpha = 1
                indicatorFocused.alpha = 0
            }
        }
    }
    
    // MARK: private functions
    
    private func updateFocusIndicator(intention: Intention) {
        indicatorName.text = intention.name
        indicatorGoalTime.text = intention.goalText
        indicatorProgressTime.text = intention.progressText
        indicatorProgressPercent.text = String(Int(floor((intention.progressInMinutes / intention.goalInMinutes) * 100))) + "%"
        indicatorProgressChart.chartValue = Float(intention.progressInMinutes / intention.goalInMinutes)
    }
}
