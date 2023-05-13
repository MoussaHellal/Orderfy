//
//  OrderDetailsPresenter.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

protocol OrderDetailsPresentationLogic
{
  func presentOrder(response: OrderDetails.GetOrder.Response)
}

class OrderDetailsPresenter: OrderDetailsPresentationLogic
{
  weak var viewController: OrderDetailsDisplayLogic?
  
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateStyle = .medium
      dateFormatter.timeStyle = .medium
    return dateFormatter
  }()
  
  // MARK: - Get order
  
  func presentOrder(response: OrderDetails.GetOrder.Response)
  {
    let order = response.order
    
    let date = dateFormatter.string(from: order.date)
      let displayedOrder = OrderDetails.GetOrder.ViewModel.DisplayedOrder(id: order.id, date: date, status: order.status)

    
    let viewModel = OrderDetails.GetOrder.ViewModel(displayedOrder: displayedOrder)
    viewController?.displayOrderDetails(viewModel: viewModel)
  }
}
