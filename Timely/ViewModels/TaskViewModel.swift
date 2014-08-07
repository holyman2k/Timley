//
//  TaskViewModel.swift
//  Timely
//
//  Created by Charlie Wu on 1/07/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation
import CoreData

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
            t.sort = lastTaskSort(context) + 1
            t.completed = false
        } else {
            t = task;
            TaskNotificationService.removeNotification(t)
        }

        t.name = name!;
        if let d = dueDate {
            t.dueDate = d;
            t.cycle = cycle
        }

        context.save(nil)

        TaskNotificationService.createNotification(t)
        TaskNotificationService.resetBadge(context)
        TaskNotificationService.resetNotificationBadgeCount()
        task = t
    }

    func delete(context:NSManagedObjectContext) {
        if let t = task {

            TaskNotificationService.removeNotification(t)
            context.deleteObject(t)
            TaskNotificationService.resetBadge(context)
            context.save(nil)
        }
    }

    func done(context:NSManagedObjectContext) {
        assert(task != nil)
        assert(task!.taskId != nil)

        if cycle > 0 {
            var newTask:Task = Task.createInContext(context);
            newTask.generateTaskId()
            newTask.name = name!;
            newTask.cycle = cycle
            newTask.sort = lastTaskSort(context) + 1
            newTask.completed = false
            if let due = dueDate {
                newTask.dueDate = due.dateByAddingTimeInterval(cycle.d * 60*60*24)
            }
            TaskNotificationService.removeNotification(task!)
            task!.completed = true
            context.save(nil)
            TaskNotificationService.createNotification(newTask)
            TaskNotificationService.resetBadge(context)
            TaskNotificationService.resetNotificationBadgeCount()
        } else  {
            TaskNotificationService.removeNotification(task!)
            TaskNotificationService.resetBadge(context)
            TaskNotificationService.resetNotificationBadgeCount()
            task!.completed = true
            context.save(nil)
        }
    }

    private func lastTaskSort(context:NSManagedObjectContext) -> Int {
        let fetchReqest = Task.fetchRequest([NSSortDescriptor(key: "sort", ascending: false)], predicate: nil)
        fetchReqest.fetchLimit = 1

        let tasks = context.executeFetchRequest(fetchReqest, error: nil) as Array<Task>

        if tasks.count > 0 {
            return tasks[0].sort;
        }
        return 0
    }
}