//
//  OrderDetailnteractor.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

protocol OrderDetailsBusinessLogic
{
  func getOrder(request: OrderDetails.GetOrder.Request)
}

protocol OrderDetailsDataStore
{
  var order: Order! { get set }
}

class OrderDetailsInteractor: OrderDetailsBusinessLogic, OrderDetailsDataStore
{
  var presenter: OrderDetailsPresentationLogic?
  
  var order: Order!
  
  // MARK: - Get order
  
  func getOrder(request: OrderDetails.GetOrder.Request)
  {
    let response = OrderDetails.GetOrder.Response(order: order)
    presenter?.presentOrder(response: response)
  }
}
