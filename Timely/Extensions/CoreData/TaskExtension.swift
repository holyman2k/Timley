//
//  TaskExtension.swift
//  Timely
//
//  Created by Charlie Wu on 16/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit

extension Task :Printable, Equatable {

    func generateTaskId() {
        taskId = NSUUID().UUIDString
    }

    func createNotification() {
        if let due = dueDate {
            var notification = UILocalNotification();
            notification.fireDate = dueDate;
            notification.alertAction = "OK"
            notification.alertBody = "\(name) is due"
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1;

            notification.userInfo = ["task-id" : taskId];
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            NSLog("create notification for task \(self) with info \(taskId)")
        } else {
            NSLog("did not create notification")
        }
    }

    func isDue() -> Bool {
        if let due = dueDate {
            return dueDate.timeIntervalSince1970 < NSDate.date().timeIntervalSince1970
        }
        return false
    }

    func removeNotification() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification :AnyObject in notifications {
                var note = notification as UILocalNotification
                if note.userInfo["task-id"] as String == taskId {
                    UIApplication.sharedApplication().cancelLocalNotification(note)
                    NSLog("remove notification for task \(self)")
                }
            }
        }
    }

    func dueDateString() -> String? {
        return Task.dueDateString(dueDate)
    }

    func repeatString() -> String {
        
        return Task.repeatString(cycle.integerValue)
    }

    func completeTask()->(Task?) {
        var newTask:Task?
        if let cycle = self.cycle?.integerValue {
            if cycle > 0 {
                newTask = Task.createInContext(self.managedObjectContext) as Task;
                newTask!.name = self.name
                newTask!.cycle = cycle
                if let due = self.dueDate {
                    var dueInSeconds = cycle * 60 * 60 * 24
                    newTask!.dueDate = due.addTimeInterval(NSTimeInterval(dueInSeconds)) as NSDate
                }
                newTask!.generateTaskId()
                newTask!.createNotification()
            }

            self.removeNotification()
            self.managedObjectContext.deleteObject(self)
            Task.resetBadgeInContext(self.managedObjectContext)
        }

        return newTask;
    }

    func deleteTask() {
        self.removeNotification()
        self.managedObjectContext.deleteObject(self)
        Task.resetBadgeInContext(self.managedObjectContext)
    }

    override var description: String {
        return "task: \(name), due: \(dueDate.dateTimeStringLong()), repeat: \(cycle)";
    }

    class func resetBadgeInContext(context:NSManagedObjectContext) {
        var predicate = NSPredicate(format: "dueDate < %@", NSDate.date())
        var request = Task.fetchRequest(nil, predicate: predicate);

        var count = context.countForFetchRequest(request, error: nil)
        NSLog("reset badge to \(count)")
        UIApplication.sharedApplication().applicationIconBadgeNumber = count;

    }

    class func dueDateString(date:NSDate?) -> String? {
        if let dueDate = date {
            return "Due: \(dueDate.dateTimeStringLong())"
        } else {
            return nil
        }
    }

    class func repeatString(days:Int) -> String {

        var postfix = days > 1 ? "s" : ""
        return days > 0 ? "Every \(days) day\(postfix)" : "Never repeat"
    }
}

func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.name == rhs.name && lhs.cycle == rhs.cycle && lhs.dueDate == rhs.dueDate
}