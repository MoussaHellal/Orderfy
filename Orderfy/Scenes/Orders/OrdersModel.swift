//
//  OrdersModel.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

enum Orders
{
  // MARK: Use cases
  
  enum FetchOrders
  {
    struct Request
    {
    }
    struct Response
    {
      var orders: [Order]
    }
    struct ViewModel
    {
      struct DisplayedOrder
      {
        var id: Int
        var date: String
        var status: OrderStatus
      }
      var displayedOrders: [DisplayedOrder]
    }
  }
}
