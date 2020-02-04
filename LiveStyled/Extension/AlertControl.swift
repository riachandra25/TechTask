//
//  AlertControl.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import UIKit

protocol AlertControl {
  
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension AlertControl where Self: UIViewController {
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
    guard presentedViewController == nil else {
      return
    }

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions?.forEach { action in
      alertController.addAction(action)
    }
    present(alertController, animated: true)
  }
}
