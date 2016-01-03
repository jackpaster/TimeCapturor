//
//  LocalNotification.swift
//  TimeCapturor
//
//  Created by YangTengfei on 1/1/16.
//  Copyright © 2016 TengfeiYang. All rights reserved.
//

import Foundation
import UIKit


extension ViewController {
    
    
    func cancelNotification() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func permissonNotification(){
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
    
    func scheduleLocal(time:NSDate){
//        if let settings = UIApplication.sharedApplication().currentUserNotificationSettings(){
//            if settings.types == .None {
//                let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//                presentViewController(ac, animated: true, completion: nil)
//                return
//            }
            notification.fireDate = time
            notification.alertBody = "It's time to capture your momoent!"
            notification.alertAction = "be awesome!"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = NSCalendar.currentCalendar().timeZone
            notification.repeatInterval = NSCalendarUnit.Day
            notification.applicationIconBadgeNumber = 1
            // notification.alertLaunchImage
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        }
    }
    
}
