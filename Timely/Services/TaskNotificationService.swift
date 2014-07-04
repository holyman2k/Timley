//
//  NotificationService.swift
//  Timely
//
//  Created by Charlie Wu on 1/07/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

class TaskNotificationService {

    //
    // this is broken becau
    //
    class func createNotification(task:Task) {
//        assert(task != nil, "")
//        assert(task.taskId != nil, "")
//
//        if let due = task.dueDate {
//            var notification = UILocalNotification()
////            notification.fireDate = due
//            notification.fireDate = NSDate.date().addTimeInterval(10) as NSDate
//            notification.alertAction = "OK"
//            notification.alertBody = "\(task.name) is due"
//            notification.timeZone = NSTimeZone.defaultTimeZone()
//            notification.userInfo = ["task-id" : task.taskId];
//            UIApplication.sharedApplication().scheduleLocalNotification(notification)
//            NSLog("create notification for task \(self) with info \(task.taskId) at date: \(notification.fireDate.dateTimeStringLong())")
//        } else {
//            NSLog("did not create notification")
//        }
//        self._resetNotificationBadgeCount()
    }

    class func removeNotification(task:Task) {
//        assert(task != nil, "")
//        assert(task.taskId != nil, "")
//
//        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
//            for notification : AnyObject in notifications {
//                let note = notification as UILocalNotification
//                if note.userInfo["task-id"] as String == task.taskId {
//                    UIApplication.sharedApplication().cancelLocalNotification(note)
//                    NSLog("remove notification for task \(task.name) id: \(task.taskId)")
//                }
//            }
//        }
//        self._resetNotificationBadgeCount()
    }

    class func resetBadge(context:NSManagedObjectContext) {
//        var predicate = NSPredicate(format: "dueDate < %@", NSDate.date())
//        var request = Task.fetchRequest(nil, predicate: predicate);
//
//        var count = context.countForFetchRequest(request, error: nil)
//        NSLog("reset badge to \(count)")
//        UIApplication.sharedApplication().applicationIconBadgeNumber = count;
    }

    class func _resetNotificationBadgeCount() {
//        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
//            notifications.sort({(obj1, obj2) -> Bool in
//                let note1 = obj1 as UILocalNotification;
//                let note2 = obj2 as UILocalNotification;
//
//                return note2.fireDate.timeIntervalSince1970 > note1.fireDate.timeIntervalSince1970
//            });
//
//            var badgeCount = UIApplication.sharedApplication().applicationIconBadgeNumber;
//            for notification : AnyObject in notifications {
//                badgeCount++
//
//                let note = notification as UILocalNotification
//
//                note.applicationIconBadgeNumber = badgeCount
//
//                UIApplication.sharedApplication().cancelLocalNotification(note)
//                UIApplication.sharedApplication().scheduleLocalNotification(note)
//
//                NSLog("note at time \(note.fireDate), badge: \(note.applicationIconBadgeNumber)")
//            }
//        }
    }


}

