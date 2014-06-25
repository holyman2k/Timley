//
//  TaskViewController.swift
//  Timely
//
//  Created by Charlie Wu on 15/06/2014.
//  Copyright (c) 2014 Charlie Wu. All rights reserved.
//

import UIKit

class TaskViewController: UITableViewController, UITextFieldDelegate, UIActionSheetDelegate {

    @IBOutlet var nameField : UITextField
    @IBOutlet var dueDatePicker : UIDatePicker
    @IBOutlet var repeatLabel : UILabel
    @IBOutlet var dueDateLabel: UILabel
    @IBOutlet var dueDateClearButton: UIButton
    @IBOutlet var repeatSteper : UIStepper
    @IBOutlet var deleteButton : UIButton
    @IBOutlet var doneButton : UIButton

    var dueDate:NSDate? {
    didSet {
        dueDateLabel.text = dueDate != nil ? Task.dueDateString(dueDate) : "Due Date"
        dueDateClearButton.hidden = dueDate == nil
    }
    }
    var task: Task?
    var context:TimelyContext {
        return TimelyContext.managed();
    }

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self;

        if let t = task {
            nameField.text = t.name
            if let taskDueDate = t.dueDate {
                dueDatePicker.date = t.dueDate
                dueDate = t.dueDate
            }
            repeatLabel.text = t.repeatString()
            repeatSteper.value = t.cycle.doubleValue

        } else {
            dueDate = nil
            deleteButton.hidden = true
            doneButton.hidden = true
        }
        dueDateClearButton.hidden = true
    }

    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        if task == nil {
            nameField.becomeFirstResponder()
        }
    }

    @IBAction func onRepeatSteperChange(sender : UIStepper) {
        self.repeatLabel.text = Task.repeatString(Int(sender.value))
    }

    @IBAction func clearDueDate(sender: AnyObject) {
        dueDate = nil;
    }

    @IBAction func saveTask(sender : AnyObject) {

        if nameField.text.isEmpty {
            nameField.layer.borderColor = UIColor(red: 0.77, green: 0.22, blue: 0.21, alpha: 1).CGColor
            nameField.layer.borderWidth = 0.5
            nameField.layer.cornerRadius = 8
            return
        } else {
            nameField.leftView = UIView(frame: CGRectMake(0, 0, 8, 1));
            nameField.layer.borderWidth = 0
        }

        if task == nil {
            task = Task.createInContext(context) as Task
            task!.generateTaskId()
        }
        if let t = task {
            t.name = nameField.text;
            t.dueDate = dueDate;
            t.cycle = Int(repeatSteper.value)
            context.save(nil)
            t.removeNotification()
            t.createNotification()
            Task.resetBadgeInContext(context)
        }
        self.navigationController.popViewControllerAnimated(true);
    }

    @IBAction func done(sender : AnyObject) {
        if let cycle = task?.cycle.integerValue {
            if cycle > 0 {
                var newTask:Task = Task.createInContext(context);
                newTask.name = nameField.text;
                newTask.cycle = Int(repeatSteper.value)
                if let due = self.dueDate {
                    newTask.dueDate = due.addTimeInterval(repeatSteper.value * 60*60*24) as NSDate
                }
                newTask.generateTaskId()
                context.save(nil)
                newTask.createNotification()
            }

            task!.removeNotification()
            context.deleteObject(self.task)
            Task.resetBadgeInContext(self.context)
            context.save(nil)

        }

        self.navigationController.popViewControllerAnimated(true);
    }
    
    @IBAction func deleteTask(sender : AnyObject) {

//        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
//        var deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {(alertAction:UIAlertAction!)->() in
//            self.deleteTask()
//        })
//
//        var alertController = UIAlertController();
//        alertController.addAction(cancelAction);
//        alertController.addAction(deleteAction);
//        presentViewController(alertController, animated: true, completion: nil)

        var actionSheet = UIActionSheet()
        actionSheet.addButtonWithTitle("Yes");
        actionSheet.addButtonWithTitle("No");
        actionSheet.destructiveButtonIndex = 0;
        actionSheet.title = "Delete";
        actionSheet.delegate = self;

        actionSheet.showInView(self.view);
    }

    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {

        if (buttonIndex == 0) {
            self.deleteTask()
        }
    }
    @IBAction func dueDatePickerChanged(sender: UIDatePicker) {
        dueDate = sender.date;
    }

    func deleteTask() {

        self.task!.removeNotification()
        context.deleteObject(self.task)
        Task.resetBadgeInContext(self.context)

        context.save(nil)

        self.navigationController.popViewControllerAnimated(true);
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {

        textField.resignFirstResponder()
        return true;
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {

        if indexPath.row == 1 {
            self.dueDateLabel.textColor = self.dueDateLabel.textColor == self.view.tintColor ? UIColor(white: 0.36, alpha: 1) : self.view.tintColor;
            var datePickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)

            dueDateClearButton.hidden = self.dueDateLabel.textColor != self.view.tintColor && self.dueDate != nil
            if (dueDate == nil) { dueDate = dueDatePicker.date }
            tableView.beginUpdates()
            tableView.reloadData()
            tableView.endUpdates()
        }
    }

    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            return 80.0
        case 1:
            return 30.0
        case 2:
            return dueDateLabel.textColor == view.tintColor ? 200.0 : 0
        case 3:
            return dueDate != nil || dueDateLabel.textColor == view.tintColor ? 44: 0
        default:
            return 44
        }
    }
}
