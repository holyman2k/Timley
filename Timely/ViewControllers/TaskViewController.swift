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

    var taskViewModel: TaskViewModel!
    var context:TimelyContext {
        return TimelyContext.managed();
    }

    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self;

        if let t = taskViewModel {
            nameField.text = t.name
            if let taskDueDate = t.dueDate {
                dueDatePicker.date = t.dueDate
                self.dueDateLabel.text = "due \(t.dueDate)"
            }
            repeatLabel.text = t.repeatString
            repeatSteper.value = t.cycle.d

        } else {
            taskViewModel = TaskViewModel(task: nil)
            deleteButton.hidden = true
            doneButton.hidden = true
        }

        taskViewModel.cycleBinding = { (cycle:Int) -> () in
            self.repeatLabel.text = self.taskViewModel.repeatString
        }

        taskViewModel.dueDateBinding = { (dueDate:NSDate?) -> () in

            switch dueDate {
            case let due where due == nil:
                self.dueDateLabel.text =  "Due Date"
                self.dueDateClearButton.hidden = true
                self.dueDatePicker.setDate(NSDate.date(), animated: true)
            default:
                self.dueDateLabel.text = "Due \(dueDate!.dateTimeStringLong())"
                self.dueDateClearButton.hidden = false
            }
        }
    }

    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        if taskViewModel.taskId == nil {
            nameField.becomeFirstResponder()
        }
    }

    // # IBActions
    @IBAction func nameFieldChange(textField:UITextField) {
        taskViewModel.name = textField.text
    }

    @IBAction func onRepeatSteperChange(sender : UIStepper) {
        self.taskViewModel.cycle = Int(sender.value)
    }

    @IBAction func clearDueDate(sender: AnyObject) {
        self.taskViewModel.dueDate = nil;
    }

    @IBAction func dueDatePickerChanged(sender: UIDatePicker) {
        self.taskViewModel.dueDate = sender.date;
    }

    @IBAction func saveTask(sender : AnyObject) {

        if taskViewModel.isTaskNameValid {
            nameField.leftView = UIView(frame: CGRectMake(0, 0, 8, 1));
            nameField.layer.borderWidth = 0
        } else {
            nameField.layer.borderColor = UIColor(red: 0.77, green: 0.22, blue: 0.21, alpha: 1).CGColor
            nameField.layer.borderWidth = 0.5
            nameField.layer.cornerRadius = 8
            return
        }

        taskViewModel.save(context)
        self.navigationController.popViewControllerAnimated(true);
    }

    @IBAction func done(sender : AnyObject) {

        taskViewModel.done(context)
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
            taskViewModel.delete(context)
            self.navigationController.popViewControllerAnimated(true);
        }
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {

        textField.resignFirstResponder()
        return true;
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {

        if indexPath.row == 1 {
            dueDateLabel.textColor = self.dueDateLabel.textColor == self.view.tintColor ? UIColor(white: 0.36, alpha: 1) : self.view.tintColor;
            dueDateClearButton.hidden = self.dueDateLabel.textColor != self.view.tintColor && taskViewModel.dueDate != nil
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
            return taskViewModel.dueDate != nil || dueDateLabel.textColor == view.tintColor ? 44: 0
        default:
            return 44
        }
    }
}
