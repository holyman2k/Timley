//
//  CoreDataExtensions.swift
//  Timely
//
//  Created by Charlie Wu on 15/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {

    class func createInContext<T where T:NSManagedObject>(context:NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: context) as T;
    }

    class func entityName() -> String {
        var name = NSStringFromClass(self)
        return name;
    }

    class func fetchRequest() -> NSFetchRequest {
        return fetchRequest(nil, predicate: nil)
    }

    class func fetchRequest(sortDescriptors:NSSortDescriptor[]?, predicate:NSPredicate?) -> NSFetchRequest {
        var entityName = self.entityName()
        var request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = sortDescriptors;
        request.predicate = predicate;

        return request;
    }
}