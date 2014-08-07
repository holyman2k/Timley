//
//  TaskExtension.swift
//  Timely
//
//  Created by Charlie Wu on 16/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit
import CoreData

extension Task :Printable, Equatable {

    func generateTaskId() {
        taskId = NSUUID().UUIDString
    }

    func isDue() -> Bool {
        if dueDate != nil {
            return dueDate.timeIntervalSince1970 < NSDate.date().timeIntervalSince1970
        }
        return false
    }

    func dueDateString() -> String? {
        return Task.dueDateString(dueDate)
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

    func repeatString() -> String {
        switch cycle.integerValue {
        case nil:
            fallthrough
        case 0:
            return "Never Repeat"
        case 1:
            return "Repeat Every Day"
        default:
            return  "Repeat Every \(cycle) days"
        }
    }

    override var description: String {
        return "task: \(name), due: \(dueDate.dateTimeStringLong()), repeat: \(cycle)";
    }
}

func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.name == rhs.name && lhs.cycle == rhs.cycle && lhs.dueDate == rhs.dueDate
}