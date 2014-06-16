//
//  TimelyTests.swift
//  TimelyTests
//
//  Created by Charlie Wu on 15/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import XCTest
import Timely
import CoreData

class TimelyTests: XCTestCase {

    func createManagedObjectContext() -> TimelyContext {
        var context:TimelyContext = TimelyContext.createInMemoryContext(.MainQueueConcurrencyType);
        return context;
    }
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        var context = createManagedObjectContext();
        var task = NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: context) as Task!

        task!.name = "wash hair"

        context.saveContext()

        var fetchRequest = NSFetchRequest(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)];

        var tasks = context.executeFetchRequest(fetchRequest, error: nil)

        XCTAssertEqual(tasks.count, 1, "")
    }

    func testExtension() {
        var context = createManagedObjectContext();

        var task:Task = Task.createInContext(context);
        task.name = "wash hair"
        context.saveContext()

        var fetchRequest = NSFetchRequest(entityName: "Task")

        var tasks = context.executeFetchRequest(fetchRequest, error: nil)

        XCTAssertEqual(tasks.count, 1, "")
        XCTAssertNotEqual(tasks.count, 2, "")
    }

    func testDate() {
        var interval:NSTimeInterval = 424585509;

        var date = NSDate(timeIntervalSince1970: interval);

        println(date)
    }

    func testTaskId() {
        var context = createManagedObjectContext();

        var task:Task = Task.createInContext(context)

        task.generateTaskId()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
