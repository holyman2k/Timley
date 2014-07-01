//
//  NotificationService.swift
//  Timely
//
//  Created by Charlie Wu on 1/07/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

class TaskNotificationService {

    class func createNotification(task:Task) {
        assert(task != nil, "")
        assert(task.taskId != nil, "")

        if let due = task.dueDate {
            var notification = UILocalNotification();
            notification.fireDate = due;
            notification.alertAction = "OK"
            notification.alertBody = "\(task.name) is due"
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1;

            notification.userInfo = ["task-id" : task.taskId];
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            NSLog("create notification for task \(self) with info \(task.taskId)")
        } else {
            NSLog("did not create notification")
        }
    }

    class func removeNotification(task:Task) {
        assert(task != nil, "")
        assert(task.taskId != nil, "")

        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification : AnyObject in notifications {
                let note = notification as UILocalNotification
                if note.userInfo["task-id"] as String == task.taskId {
                    UIApplication.sharedApplication().cancelLocalNotification(note)
                    NSLog("remove notification for task \(task.name) id: \(task.taskId)")
                }
            }
        }
    }

    class func resetBadge(context:NSManagedObjectContext) {
        var predicate = NSPredicate(format: "dueDate < %@", NSDate.date())
        var request = Task.fetchRequest(nil, predicate: predicate);

        var count = context.countForFetchRequest(request, error: nil)
        NSLog("reset badge to \(count)")
        UIApplication.sharedApplication().applicationIconBadgeNumber = count;

    }
}

