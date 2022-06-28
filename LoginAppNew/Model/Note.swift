//
//  Note.swift
//  LoginAppNew
//
//  Created by Shabuddin on 28/05/22.
//

import Foundation

class Note {
    
    var id:String = ""
    var title:String = ""
    var description: String = ""
    var isArchive = false
    var isReminder: Bool = false
//    var reminderDate: String?
    
    init(id:String, title: String, description: String, isReminder: Bool, isArchive: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.isReminder = isReminder
//        self.reminderDate = reminderDate
        self.isArchive = isArchive
        
    }
}

