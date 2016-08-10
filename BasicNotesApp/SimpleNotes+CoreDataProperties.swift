//
//  SimpleNotes+CoreDataProperties.swift
//  BasicNotesApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 8/1/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SimpleNotes {

    @NSManaged var date: String?
    @NSManaged var text: String?
    @NSManaged var title: String?
    @NSManaged var unique: String?

}
