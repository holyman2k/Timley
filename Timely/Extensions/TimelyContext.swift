//
//  TimelyContext.swift
//  Timely
//
//  Created by Charlie Wu on 15/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import Foundation
import CoreData

class TimelyContext : ManagedObjectContext {

    class func managed() -> TimelyContext {
        
        struct instance {
            static var context : TimelyContext! = nil
        }

        if instance.context == nil {
            var context:TimelyContext = TimelyContext.createContext(.MainQueueConcurrencyType, storeName: "database.sqlite");
            instance.context = context
        }

        return instance.context!
    }
    
    override class func modelName() -> (String!){
        return "Timely"
    }
}
