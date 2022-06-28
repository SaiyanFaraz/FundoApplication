//
//  MenuOption.swift
//  LoginAppNew
//
//  Created by Shabuddin on 13/05/22.
//

import Foundation
import UIKit

enum MenuOption: Int, CustomStringConvertible {
    case Profile
    case Inbox
    case Archived
    case Reminder
    
    var description: String {
        switch self {
        case .Profile: return "Profile"
        case .Inbox: return "Inbox"
        case .Archived: return "Archived"
        case .Reminder: return "Reminder"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile: return UIImage(systemName: "person.circle") ?? UIImage()
        case .Inbox: return UIImage(systemName: "envelope.fill") ?? UIImage()
        case .Archived: return UIImage(systemName: "archivebox.circle.fill") ?? UIImage()
        case .Reminder: return UIImage(systemName: "bell.square") ?? UIImage()
        }
    }
}
