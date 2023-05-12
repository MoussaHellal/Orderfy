//
//  Order.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import Foundation

struct Order: Equatable {
  var id: Int
  var date: Date
  var status: OrderStatus
}

enum OrderStatus: String {
    case new = "New"
    case preparing = "Preparing"
    case ready = "Ready"
    case delivered = "Delivered"
}
