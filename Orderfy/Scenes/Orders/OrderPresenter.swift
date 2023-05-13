//
//  OrderPresenter.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

protocol OrdersPresentationLogic {
  func presentFetchedOrders(response: Orders.FetchOrders.Response)
  func presentNewAddedOrder(response: Orders.CreateOrder.Response)
  func presentUpdateOrder(response: Orders.UpdateOrder.Response)
  func presentOrdersAfterArchiving(response: Orders.UpdateOrder.Response)
}

class OrdersPresenter: OrdersPresentationLogic {
  weak var viewController: OrdersDisplayLogic?
  
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    return dateFormatter
  }()
  
  let currencyFormatter: NumberFormatter = {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    return currencyFormatter
  }()
  
  // MARK: - Fetch orders
  
  func presentFetchedOrders(response: Orders.FetchOrders.Response) {
    var displayedOrders: [Orders.FetchOrders.ViewModel.DisplayedOrder] = []
    for order in response.orders {
      let date = dateFormatter.string(from: order.date)
        let displayedOrder = Orders.FetchOrders.ViewModel.DisplayedOrder(id: order.id, name: order.name, date: date, status: order.status)
      displayedOrders.append(displayedOrder)
    }
    let viewModel = Orders.FetchOrders.ViewModel(displayedOrders: displayedOrders)
    viewController?.displayFetchedOrders(viewModel: viewModel)
  }
    
    func presentNewAddedOrder(response: Orders.CreateOrder.Response) {
        guard let order = response.order else {
            viewController?.displayNewOrder(viewModel: Orders.CreateOrder.ViewModel(displayedOrder: nil))
            return
        }
        let date = dateFormatter.string(from: order.date)
        let newAddedOrder = Orders.CreateOrder.ViewModel.DisplayedOrder(id: order.id, name: order.name, date: date, status: order.status)
        let viewModel = Orders.CreateOrder.ViewModel(displayedOrder: newAddedOrder)
        viewController?.displayNewOrder(viewModel: viewModel)
    }
    
    func presentUpdateOrder(response: Orders.UpdateOrder.Response) {
        guard let order = response.order else {
            let viewModel = Orders.UpdateOrder.ViewModel(displayedOrder: nil, errorMessage: response.errorMessage)
            viewController?.displayUpdatedOrder(viewModel: viewModel)
            return
        }
        let date = dateFormatter.string(from: order.date)
        let newAddedOrder = Orders.UpdateOrder.ViewModel.DisplayedOrder(id: order.id, name: order.name, date: date, status: order.status)
        let viewModel = Orders.UpdateOrder.ViewModel(displayedOrder: newAddedOrder)
        
        viewController?.displayUpdatedOrder(viewModel: viewModel)
    }
    
    func presentOrdersAfterArchiving(response: Orders.UpdateOrder.Response) {
        let order = response.order!
        let date = dateFormatter.string(from: order.date)
        let newAddedOrder = Orders.UpdateOrder.ViewModel.DisplayedOrder(id: order.id, name: order.name, date: date, status: order.status)
        let viewModel = Orders.UpdateOrder.ViewModel(displayedOrder: newAddedOrder)
        
        viewController?.displayOrdersAfterArchiving(viewModel: viewModel)
    }
}
