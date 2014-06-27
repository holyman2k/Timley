//
//  TimelyTableViewController.swift
//  Timely
//
//  Created by Charlie Wu on 15/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit
import CoreData

class TimelyTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, WXSwipeTableViewCellDelegate {

    var fetchedResultsController:NSFetchedResultsController

    var context:TimelyContext

    let addIcon = UIImageView()

    init(coder aDecoder: NSCoder!)  {

        context = TimelyContext.managed();
        var fetchRequest = Task.fetchRequest([NSSortDescriptor(key: "dueDate", ascending: true)], predicate: nil)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil);
        super.init(coder: aDecoder);

        fetchedResultsController.delegate = self;
    }

    override func viewWillLayoutSubviews() {

        let iconSize:CGFloat = 20.0
        let iconX:CGFloat = CGFloat((Double(view.frame.size.width) - Double(iconSize)) / 2.0)

        addIcon.frame = CGRectMake(iconX, -50, iconSize, iconSize)
        addIcon.image = UIImage(named: "add").imageWithRenderingMode(.AlwaysTemplate)
        view.addSubview(addIcon);
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self.tableView, selector: "reloadData", name: "appDidAppear", object: nil);
        fetchedResultsController.performFetch(nil);
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {

        switch type {
        case NSFetchedResultsChangeInsert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeDelete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeUpdate:()
            var cell = tableView.cellForRowAtIndexPath(indexPath) as TimelyTableViewCell
            configCellAtIndexPath(indexPath, cell: &cell)
        default: ()
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.endUpdates()
    }

    func configCellAtIndexPath(indexPath:NSIndexPath, inout cell:TimelyTableViewCell) {
        cell.delegate = self;
        var task = fetchedResultsController.objectAtIndexPath(indexPath) as Task;
        cell.setTask(task)
    }

    // #pragma mark - Table view data source

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections[section].numberOfObjects
    }

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        if var cell = tableView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)  as TimelyTableViewCell! {
            configCellAtIndexPath(indexPath!, cell: &cell);
            return cell
        }

        return nil;
    }

    func tableViewCellDidEndSwipeWithState(cell:WXSwipeTableViewCell, state:Int, direction:Int) {

        var swipeState = SwipeState.Create(state)
        var swipeDirection = SwipeDirection.Create(direction)

        switch (swipeState, swipeDirection) {
        case (.ShortSwipe, .DirectionRight):
            cell.animateSwipe(direction: .DirectionRight, completed: {
                var indexPath = self.tableView.indexPathForCell(cell);
                var task = self.fetchedResultsController.objectAtIndexPath(indexPath) as Task;
                task.completeTask();
                self.context.save(nil);
            })
        case (.LongSwipe, .DirectionRight):
            cell.animateSwipe(direction: .DirectionRight, completed: {
                var indexPath = self.tableView.indexPathForCell(cell);
                var task = self.fetchedResultsController.objectAtIndexPath(indexPath) as Task;
                task.deleteTask();
                self.context.save(nil);
            })
        default:
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
    }

    func tableViewCellChangedSwipeWithState(cell:WXSwipeTableViewCell, state:Int, direction:Int) {

        var indexPath = tableView.indexPathForCell(cell);
        var task = fetchedResultsController.objectAtIndexPath(indexPath) as Task;

        var swipeState = SwipeState.Create(state)
        var swipeDirection = SwipeDirection.Create(direction)

        switch (swipeState, swipeDirection) {
        case (.ShortSwipe, .DirectionRight):
            cell.backgroundColor = UIColor.colorTaskCompleted()
        case (.LongSwipe, .DirectionRight):
            cell.backgroundColor = UIColor.colorTaskDelete()
        default:
            cell.backgroundColor = UIColor.whiteColor()
        }
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

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
}
