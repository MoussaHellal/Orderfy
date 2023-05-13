//
//  UIAlertController+Extensions.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation
import UIKit

extension UIAlertController {
    func isValidOrderName(_ orderName: String) -> Bool {
        return orderName.count > 0
    }

    @objc func textDidChangeInLoginAlert() {
        if let orderName = textFields?[0].text, let action = actions.last {
            action.isEnabled = isValidOrderName(orderName)
        }
    }
}
