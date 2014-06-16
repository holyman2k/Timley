//
//  TaskExtension.swift
//  Timely
//
//  Created by Charlie Wu on 16/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit

extension Task {

    func generateTaskId() {
        taskId = NSUUID().UUIDString
    }

    func createNotification() {
        
        var notification = UILocalNotification();
        notification.fireDate = dueDate;
        notification.alertAction = "OK"
        notification.alertBody = "\(name) is due"
        notification.timeZone = NSTimeZone.defaultTimeZone()

        notification.userInfo = ["task-id" : taskId];
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    func removeNotification() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification :AnyObject in notifications {
                var note = notification as UILocalNotification
                if note.userInfo["task-id"] as String == taskId {
                    UIApplication.sharedApplication().cancelLocalNotification(note)
                }
            }
        }
    }
}