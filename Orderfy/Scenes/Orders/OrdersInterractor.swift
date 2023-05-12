//
//  OrdersInterractor.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

protocol OrdersBusinessLogic {
  func fetchOrders(request: Orders.FetchOrders.Request)
}

protocol OrdersDataStore {
  var orders: [Order]? { get }
}

class ListOrdersInteractor: OrdersBusinessLogic, OrdersDataStore {
  var presenter: OrdersPresentationLogic?
  
  var ordersWorker = OrdersWorker(ordersStore: OrdersMemStore())
  var orders: [Order]?
  
  // MARK: - Fetch orders
  
  func fetchOrders(request: Orders.FetchOrders.Request) {
    ordersWorker.fetchOrders { (orders) -> Void in
      self.orders = orders
      let response = Orders.FetchOrders.Response(orders: orders)
      self.presenter?.presentFetchedOrders(response: response)
    }
  }
}
