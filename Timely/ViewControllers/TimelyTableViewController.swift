//
//  TimelyTableViewController.swift
//  Timely
//
//  Created by Charlie Wu on 15/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit
import CoreData

class TimelyTableViewController: WXReorderTableTableViewController, WXReorderTableViewDelegate, NSFetchedResultsControllerDelegate, WXSwipeTableViewCellDelegate {

    var fetchedResultsController:NSFetchedResultsController

    var context:TimelyContext

    let addIcon = UIImageView()

    required init(coder aDecoder: NSCoder!)  {

        context = TimelyContext.managed();

//        let fetchRequest = NSFetchRequest(entityName: "Task")
//        fetchRequest.predicate = NSPredicate(format: "completed = %@", false)
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sort", ascending: true)]


        var fetchRequest = Task.fetchRequest([NSSortDescriptor(key: "sort", ascending: true)], predicate: NSPredicate(format: "completed = %@", false))
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil);
        super.init(coder: aDecoder);

        fetchedResultsController.delegate = self;
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        let iconSize = 20.0
        let iconX = (view.frame.size.width.d - iconSize) / 2.0

        addIcon.frame = CGRectMake(iconX.f, -50, iconSize.f, iconSize.f)
        addIcon.image = UIImage(named: "add").imageWithRenderingMode(.AlwaysTemplate)
        view.addSubview(addIcon)

        NSNotificationCenter.defaultCenter().addObserver(self.tableView, selector: "reloadData", name: "appDidAppear", object: nil);
        fetchedResultsController.performFetch(nil);

        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, tableView.frame.size.width)

        reorderDelegate = self;
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {

        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Update:
            var cell = tableView.cellForRowAtIndexPath(indexPath) as TimelyTableViewCell
            configCellAtIndexPath(indexPath, cell: &cell)
        default: ()
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.endUpdates()
    }

    func swapObjectAtIndexPath(fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
//        WXTask *fromTask = [self.fetchedResultsController objectAtIndexPath:fromIndexPath];
//        WXTask *toTask = [self.fetchedResultsController objectAtIndexPath:toIndexPath];
//
//        NSNumber *fromTaskSort = fromTask.sort;
//
//        fromTask.sort = toTask.sort;
//        toTask.sort = fromTaskSort;
//
//        [[self managedObjectContext] save:nil];
        var fromTask = fetchedResultsController.objectAtIndexPath(fromIndexPath) as Task
        var toTask =  fetchedResultsController.objectAtIndexPath(toIndexPath) as Task

        let fromSort = fromTask.sort

        fromTask.sort = toTask.sort
        toTask.sort = fromSort

        context.save(nil);

    }

    func configCellAtIndexPath(indexPath:NSIndexPath, inout cell:TimelyTableViewCell) {
        cell.delegate = self;
        var task = fetchedResultsController.objectAtIndexPath(indexPath) as Task;

        if let reorderIndexPath = indexPathOfReorderingCell {
            if indexPath.row == indexPathOfReorderingCell.row {
                cell.taskNameLabel.text = nil
                cell.taskDueDateLabel.text = nil
                return
            }
        }

        cell.taskNameLabel.text = task.name;
        cell.taskDueDateLabel.text = task.dueDateString()

        cell.taskNameLabel.textColor = task.isDue() ? UIColor.colorTaskNameDue() : UIColor.colorTaskName()

        cell.taskNameTopConstraint.constant = task.dueDateString() == nil ? 20 : 10;
        cell.updateConstraints()
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
                TaskViewModel(task: task).done(self.context)
            })
        case (.LongSwipe, .DirectionRight):
            cell.animateSwipe(direction: .DirectionRight, completed: {
                var indexPath = self.tableView.indexPathForCell(cell);
                var task = self.fetchedResultsController.objectAtIndexPath(indexPath) as Task;
                TaskViewModel(task: task).delete(self.context)
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
                    let taskViewModel = TaskViewModel(task:task as Task)
                    controller.taskViewModel = taskViewModel
                }
            }
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
}
