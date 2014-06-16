//
//  TimelyTableViewController.swift
//  Timely
//
//  Created by Charlie Wu on 15/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit
import CoreData

class TimelyTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController:NSFetchedResultsController

    var context:TimelyContext

    init(coder aDecoder: NSCoder!)  {

        context = TimelyContext.managed();
        var fetchRequest = Task.fetchRequest([NSSortDescriptor(key: "name", ascending: true)], predicate: nil)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil);
        super.init(coder: aDecoder);

        fetchedResultsController.delegate = self;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        fetchedResultsController.performFetch(nil);
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData();
    }

    // #pragma mark - Table view data source

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections[section].numberOfObjects
    }


    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        if let cell = tableView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)  as UITableViewCell! {

            var task = fetchedResultsController.objectAtIndexPath(indexPath) as Task;
            cell.textLabel!.text = task.name;
            cell.detailTextLabel!.text = "due: \(task.dueDate.dateTimeStringLong())"

            if (task.dueDate.timeIntervalSince1970 < NSDate.date().timeIntervalSince1970) {
                cell.textLabel.textColor = UIColor(red: 0.77, green: 0.22, blue: 0.21, alpha: 1)

            } else {
                cell.textLabel.textColor = UIColor(white: 0.37, alpha: 1)
            }
            return cell
        }

        return nil;
    }

    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {

        if (segue!.identifier == "edit") {
            if  let task = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow()) as Task! {
                if let controller = segue!.destinationViewController as TaskViewController! {
                    controller.task = task as Task;
                }
            }
        }

    }

    override func shouldAutorotate() -> Bool  {
        return false
    }
}
