//
//  ViewController.swift
//  Checklists
//
//  Created by chuwei on 10/16/14.
//  Copyright (c) 2014 yaming. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    /*required init(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = true
        items.append(row4item)
        
        super.init(coder: aDecoder)

        	loadChecklistItems()
        
        println("Documents folder is \(documentsDirectory())")
        println("Data file path is \(dataFilePath())")
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            let data = NSData(contentsOfFile: path)
            if (data != nil) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
                items = unarchiver.decodeObjectForKey("ChecklistItems") as [ChecklistItem]
                unarchiver.finishDecoding()
            }

            let b = 0
        }
    }*/
    
    //var items: [ChecklistItem]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return checklist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
        
        let item = checklist.items[indexPath.row]

        configureTextForCell(cell, withChecklistItem: item)
        
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: item)
        
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //saveChecklistItems()
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
            let label = cell.viewWithTag(1001) as UILabel
            
            if item.checked {
                label.text = "☑️"
            } else {
                label.text = ""
            }
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.text
        //label.text = "\(item.itemID): \(item.text)"
        
        let subLabel = cell.viewWithTag(1002) as UILabel
        subLabel.text = "\(item.dueDate)"
    }
    
    // not needed after using ItemDetailViewController for adding a new item in list
    /*@IBAction func addItem() {
        let newRowIndex = items.count
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = true
        
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }*/
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checklist.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        //saveChecklistItems()
    }
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
        //saveChecklistItems()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        if let index = find(checklist.items, item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        //saveChecklistItems()
    }
    /* removed when creating multiple check lists
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        
        data.writeToFile(dataFilePath(), atomically: true)
    }*/
}
