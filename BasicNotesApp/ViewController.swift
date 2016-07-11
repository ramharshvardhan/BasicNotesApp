//
//  ViewController.swift
//  BasicNotesApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 5/13/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var savedNotes = [NSManagedObject]()
    
    var titleStringToPass: String = ""
    
    var textStringToPass: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        
        //Assigning saved values to Title and Subtitle
        let note = savedNotes[indexPath.row]
        cell.textLabel?.text = note.valueForKey("title") as? String
        cell.detailTextLabel?.text = note.valueForKey("date") as? String
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let note = savedNotes[(indexPath.row)]
        titleStringToPass = note.valueForKey("title") as! String
        textStringToPass = note.valueForKey("text") as! String
        self.performSegueWithIdentifier("readOnlySegue", sender: self) //Preparing segue to ReadOnlyViewController class
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "readOnlySegue") {
            let viewControl = segue.destinationViewController as! ReadOnlyViewController
            viewControl.titleStringPassed = titleStringToPass
            viewControl.textStringPassed = textStringToPass
        }
    }
    
    //Deleting data from a row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            managedContext.deleteObject(savedNotes[indexPath.row] as NSManagedObject)
            savedNotes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //Fetching data from saved CoreData stack
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "SimpleNotes")
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            savedNotes = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), due to \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        title = "Notes"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

