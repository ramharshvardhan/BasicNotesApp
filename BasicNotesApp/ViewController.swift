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

    var savedNotes = [SimpleNotes]()
    var savedTitle: String = ""
    var savedText: String = ""
    var uniqueNumber: String = ""
    
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
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.date
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let note = savedNotes[(indexPath.row)]
        savedTitle = note.title!
        savedText = note.text!
        uniqueNumber = note.unique!
    
        self.performSegueWithIdentifier("displaySegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "displaySegue") { //When displaying an existing record
            let notesViewControl = segue.destinationViewController as! NotesViewController
            notesViewControl.titleText = savedTitle
            notesViewControl.notesText = savedText
            notesViewControl.uniqueValueOfSavedData = uniqueNumber
        }
    }
    
    //Deleting data from a row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete { //Alert view to notify the user
            let alertView = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alertView.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { (action) in
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                managedContext.deleteObject(self.savedNotes[indexPath.row] as SimpleNotes)
                self.savedNotes.removeAtIndex(indexPath.row)
                do {    //Saving the managed context after deleting a rows
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save \(error) due to \(error.userInfo)")
                }
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    //Fetching data from saved CoreData stack
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "SimpleNotes")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor] //Filter by date
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            savedNotes = results as! [SimpleNotes]
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

