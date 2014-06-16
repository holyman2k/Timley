////
////  File.swift
////  Timely
////
////  Created by Charlie Wu on 15/06/2014.
////  Copyright (c) 2014 Charlie Wu. All rights reserved.
////
//
import Foundation
import CoreData

class ManagedObjectContext : NSManagedObjectContext {

    class func createContext<T where T: NSManagedObjectContext>(concurrencyType: NSManagedObjectContextConcurrencyType, storeName: String?) -> T {

        var modelName = self.modelName()

        // create managed object model
        let modelURL = NSBundle.mainBundle().URLForResource(modelName, withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)

        // create persistence coordinator
        let storeURL: NSURL? = storeName != nil ? self.applicationDocumentsDirectory.URLByAppendingPathComponent(storeName) : nil
        let storeType: String = storeName != nil ? NSSQLiteStoreType : NSInMemoryStoreType
        var error: NSError? = nil
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        var options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true];
        if coordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: options, error: &error) == nil {
            abort()
        }

        var context:T = T(concurrencyType: concurrencyType)
        context.persistentStoreCoordinator = coordinator
        context.mergePolicy = NSMergePolicy(mergeType: .OverwriteMergePolicyType)

        return context;
    }

    class func createInMemoryContext<T where T: NSManagedObjectContext>(concurrencyType: NSManagedObjectContextConcurrencyType) -> T {
        var context:T = self.createContext(concurrencyType, storeName: nil);
        return context;
    }

    class var applicationDocumentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }

    class func modelName() -> (String!){
        return nil;
    }

    func saveContext () {
        var error: NSError? = nil
        if self.hasChanges && !self.save(&error) {
            abort()
        }
    }


}