//
//  Task.swift
//  Timely
//
//  Created by Charlie Wu on 8/08/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)
class Task: NSManagedObject {

    @NSManaged var cycle: NSNumber
    @NSManaged var dueDate: NSDate
    @NSManaged var name: String
    @NSManaged var sort: NSNumber
    @NSManaged var taskId: String
    @NSManaged var completed: NSNumber

}
