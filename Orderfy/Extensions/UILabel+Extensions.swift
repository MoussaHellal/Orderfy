//
//  UILabel+Extensions.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation
import UIKit

extension UILabel {
    func defaultLabelSpecs() -> UILabel {
        self.textAlignment = .center
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.font = .systemFont(ofSize: 18)
        return self
    }
}
