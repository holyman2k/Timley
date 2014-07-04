//
//  TaskViewModel.swift
//  Timely
//
//  Created by Charlie Wu on 1/07/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation

class TaskViewModel {

    var task:Task?

    var dueDate:NSDate? {
    didSet {
        if let binding = dueDateBinding {
            binding(dueDate:dueDate)
        }
    }
    }

    var name:String?

    var cycle:Int = 0 {
    didSet {
        if let binding = cycleBinding {
            binding(cycle: cycle)
        }
    }
    }

    var taskId:String?

    var dueDateBinding:((dueDate:NSDate?)->())?;

    var cycleBinding:((cycle:Int)->())?

    // derived properties
    var repeatString:String {
        return Task.repeatString(cycle)
    }

    var isNew:Bool {
        return task == nil
    }

    // validation
    var isTaskNameValid:Bool {
        if let n = name {
            return !n.isEmpty
        }
        return false
    }

    init(task:Task?) {
        if let t = task {
            self.task = t
            self.dueDate = t.dueDate
            self.name = t.name
            self.cycle = t.cycle.integerValue
            self.taskId = t.taskId
        }
    }

    func save(context:NSManagedObjectContext) {

        var t:Task!
        if self.task == nil {
            t = Task.createInContext(context) as Task
            t.generateTaskId()
        } else {
            t = task;
            TaskNotificationService.removeNotification(t)
        }

        t.name = name;
        t.dueDate = dueDate
        t.cycle = cycle

        context.save(nil)

        TaskNotificationService.createNotification(t)
        TaskNotificationService.resetBadge(context)
        TaskNotificationService.resetNotificationBadgeCount()
    }

    func delete(context:NSManagedObjectContext) {
        if let t = task {

            TaskNotificationService.removeNotification(t)
            context.deleteObject(t)
            TaskNotificationService.resetBadge(context)
        }
    }

    func done(context:NSManagedObjectContext) {
        assert(task != nil)
        assert(task!.taskId != nil)

        if cycle > 0 {
            var newTask:Task = Task.createInContext(context);
            newTask.generateTaskId()
            newTask.name = name;
            newTask.cycle = cycle
            if let due = dueDate {
                newTask.dueDate = due.addTimeInterval(cycle.d * 60*60*24) as NSDate
            }
            TaskNotificationService.removeNotification(task!)
            context.deleteObject(task)
            context.save(nil)
            TaskNotificationService.createNotification(newTask)
            TaskNotificationService.resetBadge(context)
            TaskNotificationService.resetNotificationBadgeCount()
        } else  {
            TaskNotificationService.removeNotification(task!)
            TaskNotificationService.resetBadge(context)
            TaskNotificationService.resetNotificationBadgeCount()
            context.deleteObject(task)
            context.save(nil)
        }

    }
}