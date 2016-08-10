//
//  NotesViewController.swift
//  BasicNotesApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 5/13/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UITextViewDelegate {
    
    var newNotes = [SimpleNotes]()
    let date = NSDate()
    var titlePlaceholder: String = "Give a title!"
    var notesPlaceholder: String = "Go for it!"
    var titleText: String = ""
    var notesText: String = ""
    var uniqueValueOfSavedData: String = ""
    var randomNumber: String = ""

    @IBOutlet weak var titleTextField: UITextView!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        self.saveName(titleTextField.text, textString: noteTextField.text, currentDate: date, unique: randomNumber)
        navigationController?.popViewControllerAnimated(true)
    }
    
    //Saving data to DB through CoreData
    func saveName(titleString: String, textString: String, currentDate: NSDate, unique: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("SimpleNotes", inManagedObjectContext: managedContext)
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm"
        let dateString = dateFormatter.stringFromDate(currentDate)
        
        let fetchRequest = NSFetchRequest(entityName: "SimpleNotes") //SELECT statement in SQL
        fetchRequest.predicate = NSPredicate(format: "unique = %@", unique) //WHERE statement in SQL
        
        do {
            if let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [SimpleNotes] { //Updating existing notes
                if fetchResults.count != 0 {
                    let managedObject = fetchResults[0]
                    managedObject.setValue(titleString, forKey: "title")
                    managedObject.setValue(textString, forKey: "text")
                } else { //Save only when new notes are created
                    let simpleNotes = SimpleNotes(entity: entity!, insertIntoManagedObjectContext: managedContext)
                    simpleNotes.title = titleString
                    simpleNotes.text = textString
                    simpleNotes.date = dateString
                    simpleNotes.unique = unique
                    
                    do{
                        try managedContext.save()
                        newNotes.append(simpleNotes)
                    } catch let error as NSError {
                        print("Could not save \(error) due to \(error.userInfo)")
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), due to \(error.userInfo)")
        }
    }

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            textView.scrollEnabled = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if self.titleTextField.text.isEmpty {
            titleTextField.text = titlePlaceholder
            titleTextField.textColor = UIColor.lightGrayColor()
        }
        if self.noteTextField.text.isEmpty {
            noteTextField.text = notesPlaceholder
            noteTextField.textColor = UIColor.lightGrayColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        noteTextField.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false //Cursor at beginning of text view
        
        if (titleText == "") {
            title = "New Note"
            titleTextField.text = titlePlaceholder
            titleTextField.textColor = UIColor.lightGrayColor()
        } else {
            title = "Edit note"
            titleTextField.text = titleText
        }
        if (notesText == "") {
            noteTextField.text = notesPlaceholder
            noteTextField.textColor = UIColor.lightGrayColor()
        } else {
            noteTextField.text = notesText
        }
        if (uniqueValueOfSavedData == "") {
            randomNumber = "\(arc4random())"
        } else {
            randomNumber = uniqueValueOfSavedData
        }
    }
}
