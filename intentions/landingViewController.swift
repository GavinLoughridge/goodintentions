//
//  landingViewController.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/26/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit
import WatchConnectivity

class landingViewController: UIViewController, WCSessionDelegate {
    
    // MARK: properties

    @IBOutlet weak var indicatorUnfocused: UILabel!
    @IBOutlet weak var indicatorFocused: UIView!
    @IBOutlet weak var indicatorName: UILabel!
    @IBOutlet weak var indicatorGoalTime: UILabel!
    @IBOutlet weak var indicatorProgressTime: UILabel!
    @IBOutlet weak var indicatorProgressPercent: UILabel!
    @IBOutlet weak var indicatorProgressChart: progressChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        print("Message received: ",message)
//    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Begin the activation process for the new Apple Watch.
        WCSession.default.activate()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: focusUpdated,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateIndicator),
                                               name: focusUpdated,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: focusUpdated,
                                                  object: nil)
    }
    
    // MARK: public functions
    
    @objc func updateIndicator() {
        print("updating indicator")
        // only update the focus indicator if a valid focus exists
        if (focus.intention.name != "") {
            updateFocusIndicator(intention: focus.intention)
        }
        setIndicator()
        saveFocus()
    }
    
    // MARK: private functions
    
    private func updateFocusIndicator(intention: Intention) {
        indicatorName.text = intention.name
        
        indicatorGoalTime.text = String(floor(intention.goalConverted * 10) / 10) + intention.goalUnit
        
        indicatorProgressTime.text = String(floor(intention.progressConverted * 10) / 10) + intention.goalUnit
        
        indicatorProgressPercent.text = String(Int(floor((intention.progressInMinutes / intention.goalInMinutes) * 100))) + "%"
        
        indicatorProgressChart.chartValue = Float(intention.progressInMinutes / intention.goalInMinutes)
    }
    
    private func setIndicator() {
        if (focus.intention.name != "") {
            indicatorUnfocused.alpha = 0
            indicatorFocused.alpha = 1
        } else {
            //
            indicatorUnfocused.alpha = 1
            indicatorFocused.alpha = 0
        }
    }
    
    // save and load functions
    private func saveFocus() {
        NSKeyedArchiver.archiveRootObject(focus, toFile: Focus.ArchiveURL.path)
    }
}
