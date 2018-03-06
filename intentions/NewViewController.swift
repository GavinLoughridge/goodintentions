//
//  NewViewController.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/23/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit
import os.log

class NewViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var goalUnitHours: UISwitch!
    @IBOutlet weak var resetPeriodUnitWeek: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goalUnitHours.layer.cornerRadius = 16.0
        resetPeriodUnitWeek.layer.cornerRadius = 16.0
        
        // enable done button on name keypad
        self.nameTextField.delegate = self
        
        // add done button to goal field
        let goalFieldDone = UIToolbar.init()
        goalFieldDone.sizeToFit()
        let goalFieldBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                                    target: goalTextField, action: #selector(UITextField.resignFirstResponder))
        
        goalFieldDone.items = [goalFieldBtnDone]
        goalTextField.inputAccessoryView = goalFieldDone
        
        // set focus to name field
        nameTextField.perform(
            #selector(becomeFirstResponder),
            with: nil
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    

    @IBAction func attemptSave(_ sender: UIBarButtonItem) {
        let intention = Intention()
        
        intention.name = (nameTextField.text ?? "").uppercased()
        if let text = goalTextField.text {
            if let time = Float(text) {
                intention.goalInMinutes = (goalUnitHours.isOn ? (time * 60.0) : time)
            }
        }

        intention.progressResetPeriod = resetPeriodUnitWeek.isOn ? "week" : "day"

        do {
            let validator = Intention.IntentionValidator()
            try validator.validate(intention: intention)
            
            for existingIntention in IntentionModel.sharedInstance.model.intentions {
                if existingIntention.name == intention.name {
                    throw ValidationError.reason("Sorry, there is already an intention with that name.")
                }
            }
        } catch {
            let alert = UIAlertController(title: "Invalid Input",
                                          message: error.localizedDescription,
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        }

        IntentionModel.sharedInstance.addIntention(newIntention: intention)
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
