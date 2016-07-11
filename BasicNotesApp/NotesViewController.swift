//
//  NotesViewController.swift
//  BasicNotesApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 5/13/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    var newNotes = [NSManagedObject]()
    
    let date = NSDate()

    @IBOutlet weak var titleTextField: UITextView!
    
    @IBOutlet weak var noteTextField: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        self.saveName(titleTextField.text, textString: noteTextField.text, currentDate: date)
        navigationController?.popViewControllerAnimated(true)
    }
    
    //Saving data from UI to DB through CoreData
    func saveName(titleString: String, textString: String, currentDate: NSDate) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("SimpleNotes", inManagedObjectContext: managedContext)
        let simpleNotes = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        simpleNotes.setValue(titleString, forKey: "title")
        simpleNotes.setValue(textString, forKey: "text")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(currentDate)
    
        simpleNotes.setValue(dateString, forKey: "date")
        
        do{
            try managedContext.save()
            newNotes.append(simpleNotes)
        } catch let error as NSError {
            print("Could not save \(error) due to \(error.userInfo)")
        }
    }
    
    func textViewStyling(textView: UITextView) {
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 6.0
        textView.layer.masksToBounds = true
        textView.textColor = UIColor.blackColor()
        textView.opaque = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Note"
        textViewStyling(titleTextField)
        textViewStyling(noteTextField)
    }
}
