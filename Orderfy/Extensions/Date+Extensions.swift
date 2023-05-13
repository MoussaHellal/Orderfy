//
//  Date+Extensions.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation

extension String {
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        return dateFormatter.date(from: self) ?? Date()
    }
}
