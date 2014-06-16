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
    @IBOutlet var repeatSteper : UIStepper
    @IBOutlet var deleteButton : UIButton
    @IBOutlet var doneButton : UIButton
    var task: Task?
    var context:TimelyContext

    
    init(coder aDecoder: NSCoder!) {
        context = TimelyContext.managed();
        super.init(coder: aDecoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self;
        self.dueDatePicker.minuteInterval = 1

        if let t = task {
            nameField.text = t.name
            dueDatePicker.date = t.dueDate
            self.repeatLabel.text = repeatString(t.cycle.integerValue)
            self.repeatSteper.value = t.cycle.doubleValue
        } else {
            deleteButton.hidden = true
            doneButton.hidden = true
        }
    }

    @IBAction func onRepeatSteperChange(sender : UIStepper) {
        var value = Int(sender.value)
        self.repeatLabel.text = repeatString(value)
    }

    @IBAction func saveTask(sender : AnyObject) {

        if task == nil {
            task = Task.createInContext(context) as Task
        }
        if let t = task {
            t.name = nameField.text;
            t.dueDate = dueDatePicker.date;
            t.cycle = Int(repeatSteper.value)
            t.generateTaskId();
            context.save(nil);
            t.createNotification()
        }
        self.navigationController.popViewControllerAnimated(true);
    }

    @IBAction func done(sender : AnyObject) {
        var newTask:Task = Task.createInContext(context);
        newTask.name = nameField.text;
        newTask.cycle = Int(repeatSteper.value)
        newTask.dueDate = task!.dueDate.addTimeInterval(repeatSteper.value * 60*60*24) as NSDate
        newTask.generateTaskId();

        context.deleteObject(self.task);
        context.save(nil)

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

    func deleteTask() {

        self.task!.removeNotification();
        context.deleteObject(self.task)
        context.save(nil)

        self.navigationController.popViewControllerAnimated(true);
    }


    func repeatString(days:Int) -> String {
        var postfix = days > 1 ? "s" : ""
        return days > 0 ? "Every \(days) day\(postfix)" : "Never repeat"
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    override func shouldAutorotate() -> Bool  {
        return false
    }
}
