//
//  UIAlertController + Extension.swift
//  LoginAppNew
//
//  Created by Shabuddin on 13/05/22.
//

import Foundation
import UIKit
extension UITableViewController {
    public func openAlert(title: String?,
                          message: String?,
                          actionTitles:[String?],
                          actionStyle:[UIAlertAction.Style],
                          actions:[((UIAlertAction) -> Void)?],
                          vc: UIViewController) {
              let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
              for (index, title) in actionTitles.enumerated() {
                   let action = UIAlertAction(title: title, style: actionStyle[index], handler: actions[index])
                   alertController.addAction(action)
              }
              vc.present(alertController, animated: true, completion: nil)
         }
    }


