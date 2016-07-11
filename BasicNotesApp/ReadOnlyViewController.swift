//
//  ReadOnlyViewController.swift
//  BasicNotesApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 5/13/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit
import CoreData

class ReadOnlyViewController: UIViewController {
    
    var titleStringPassed: String = ""
    
    var textStringPassed: String = ""
  
    @IBOutlet weak var titleTextField: UITextView!
    
    @IBOutlet weak var noteTextField: UITextView!
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func textViewStyling(textView: UITextView) {
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 6.0
        textView.layer.masksToBounds = true
        textView.textColor = UIColor.blackColor()
        textView.opaque = true
        textView.editable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewStyling(titleTextField)
        textViewStyling(noteTextField)
        titleTextField!.text = titleStringPassed
        noteTextField!.text = textStringPassed
    }
}
