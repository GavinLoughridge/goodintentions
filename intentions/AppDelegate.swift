//
//  AppDelegate.swift
//  intentions
//
//  Created by Gavin Loughridge on 11/23/17.
//  Copyright © 2017 Gavin Loughridge. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        IntentionModel.sharedInstance.loadModel()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        NotificationCenter.default.removeObserver(self,
                                                  name: IntentionModel.sharedInstance.updatedNotification,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateContext(_:)),
                                               name: IntentionModel.sharedInstance.updatedNotification,
                                               object: nil)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NotificationCenter.default.removeObserver(self,
                                                  name: IntentionModel.sharedInstance.updatedNotification,
                                                  object: nil)
    }
}

extension AppDelegate: WCSessionDelegate {

//    update focus when changed from a watch
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let focusName = message["clicked"] as? String else{
            return
        }
        
        for intention in IntentionModel.sharedInstance.model.intentions {
            if intention.name == focusName {
                IntentionModel.sharedInstance.setFocus(intention: intention)
            }
        }
    }
    
//    send string based model to a watch when requested
    func session(_ session: WCSession,
                          didReceiveMessage message: [String : Any],
                          replyHandler: @escaping ([String : Any]) -> Void) {
        var focus = String()
        var intentions = [String]()
        
        focus = IntentionModel.sharedInstance.model.focus.intention.name
        for intention in IntentionModel.sharedInstance.model.intentions {
            intentions.append(intention.name)
        }
        
        replyHandler(["focus": focus, "intentions": intentions])
    }

//    send string based model to watch any time it changes
    @objc func updateContext(_ notification: NSNotification) {
        if let model = notification.userInfo?["model"] as? IntentionModel.Model {
            let session = WCSession.default
            var focus = String()
            var intentions = [String]()
            
            focus = model.focus.intention.name
            for intention in model.intentions {
                intentions.append(intention.name)
            }
            
            do {
                try session.updateApplicationContext(["focus": focus, "intentions": intentions])
            } catch {
                print("error")
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Begin the activation process for the new Apple Watch.
        WCSession.default.activate()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
}

