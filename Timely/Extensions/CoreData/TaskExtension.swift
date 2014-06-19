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
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1;

        notification.userInfo = ["task-id" : taskId];
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        NSLog("create notification for task \(name)")
    }

    func isDue() -> Bool {
        return dueDate.timeIntervalSince1970 < NSDate.date().timeIntervalSince1970
    }

    func removeNotification() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification :AnyObject in notifications {
                var note = notification as UILocalNotification
                if note.userInfo["task-id"] as String == taskId {
                    UIApplication.sharedApplication().cancelLocalNotification(note)
                    NSLog("remove notification for task \(name)")
                }
            }
        }
    }

    func resetBadge() {
        var context = self.managedObjectContext
        var predicate = NSPredicate(format: "dueDate < %@", NSDate.date())
        var request = Task.fetchRequest(nil, predicate: predicate);

        var count = context.countForFetchRequest(request, error: nil)
        NSLog("task due \(count)")
        UIApplication.sharedApplication().applicationIconBadgeNumber = count;
        
    }
}