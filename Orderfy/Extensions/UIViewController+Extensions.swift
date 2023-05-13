//
//  UIViewController+Extensions.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showOrderFailureAlert(title: String, message: String) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      showDetailViewController(alertController, sender: nil)
    }
}
