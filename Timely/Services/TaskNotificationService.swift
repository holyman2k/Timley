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
            var notification = UILocalNotification()
            notification.fireDate = due
            notification.alertAction = "OK"
            notification.alertBody = "\(task.name) is due"
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.userInfo = ["task-id" : task.taskId];
            notification.soundName = UILocalNotificationDefaultSoundName;
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            NSLog("create notification for task \(self) with info \(task.taskId) at date: \(notification.fireDate.dateTimeStringLong())")
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
                if let taskId: AnyObject = note.userInfo ["task-id"] {
                    let id = taskId as String
                    if id == task.taskId {
                        UIApplication.sharedApplication().cancelLocalNotification(note)
                        NSLog("remove notification for task \(task.name) id: \(task.taskId)")
                    }
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

    class func resetNotificationBadgeCount() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            NSLog("notification count \(notifications.count)")
            let notes = notifications.sorted({(obj1, obj2) -> Bool in
                let note1 = obj1 as UILocalNotification;
                let note2 = obj2 as UILocalNotification;

                return note2.fireDate.timeIntervalSince1970 > note1.fireDate.timeIntervalSince1970
            });

            var badgeCount = UIApplication.sharedApplication().applicationIconBadgeNumber
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            for notification : AnyObject in notes {
                badgeCount++
                let note = notification as UILocalNotification
                note.applicationIconBadgeNumber = badgeCount
                UIApplication.sharedApplication().scheduleLocalNotification(note)
                NSLog("set notification \(note.alertBody), due \(note.fireDate.dateTimeStringLong()), badge count \(note.applicationIconBadgeNumber)")

            }
        }
    }


}

