//
//  Order.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import Foundation
import UIKit

struct Order: Equatable {
  var id: Int
  var name: String
  var date: Date
  var status: OrderStatus
}

enum OrderStatus: String, CaseIterable {
    case new = "New"
    case preparing = "Preparing"
    case ready = "Ready"
    case delivered = "Delivered"
    
    var index: Int {
        return OrderStatus.allCases.firstIndex(of: self) ?? 0
    }
    
    var color: UIColor {
            switch self {
            case .new:
                return UIColor.systemCyan
            case .preparing:
                return UIColor.orange
            case .ready:
                return UIColor.purple
            case .delivered:
                return UIColor.blue
            }
        }
    
    var graphicRespresentive: String {
            switch self {
            case .new:
                return "🆕"
            case .preparing:
                return "⌛"
            case .ready:
                return "✔️"
            case .delivered:
                return "✅"
            }
        }
}
