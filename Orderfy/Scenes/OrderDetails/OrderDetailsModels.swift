//
//  OrderModels.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

enum OrderDetails
{
  // MARK: Use cases
  
  enum GetOrder
  {
    struct Request
    {
    }
    struct Response
    {
      var order: Order
    }
    struct ViewModel
    {
      struct DisplayedOrder
      {
          var id: Int
          var date: String
          var status: OrderStatus
      }
      var displayedOrder: DisplayedOrder
    }
  }
}
