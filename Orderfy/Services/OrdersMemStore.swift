//
//  OrdersMemStore.swift
//  Orderfy
//
//  Created by Moussa on 12/5/2023.
//

import Foundation

class OrdersMemStore: OrdersStoreProtocol {
    // MARK: - Data
    
    static var orders = [Order(id: 1, name: "Food", date: Date(), status: .new)]
    static var archivedOrders = [Order]()

    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void) {
     completionHandler { return type(of: self).orders.reversed() }
    }
    
    func fetchOrder(id: Int, completionHandler: @escaping OrdersStoreFetchOrderCompletionHandler) {
        let order = type(of: self).orders.filter { (order: Order) -> Bool in
          return order.id == id
          }.first
        if let order = order {
          completionHandler(OrdersStoreResult.Success(result: order))
        } else {
          completionHandler(OrdersStoreResult.Failure(error: OrdersStoreError.CannotFetch("Cannot fetch order with id \(id)")))
        }
      }
    
    func fetchOrder(id: Int, completionHandler: @escaping (() throws -> Order?) -> Void) {
      if let index = indexOfOrderWithID(id: id) {
        completionHandler { return type(of: self).orders[index] }
      } else {
        completionHandler { throw OrdersStoreError.CannotFetch("Cannot fetch order with id \(id)") }
      }
    }
    
    func createOrder(orderToCreate: Order, completionHandler: @escaping (Order) -> Void) {
        let order = orderToCreate
        type(of: self).orders.append(order)
        print(type(of: self).orders)
        completionHandler(order)
    }
    
    func updateOrderStatus(id: Int, status: OrderStatus, completionHandler: @escaping (() throws -> Order?) -> Void) {
        if let index = indexOfOrderWithID(id: id) {
            type(of: self).orders[index].status = status
            print(type(of: self).orders)
          let order = type(of: self).orders[index]
          completionHandler { return order }
        } else {
          completionHandler { throw OrdersStoreError.CannotUpdate("Cannot fetch order with id \(String(describing: id)) to update")
          }
        }
    }
    
    
    // MARK: - Convenience methods
    
    private func indexOfOrderWithID(id: Int?) -> Int?
    {
      return type(of: self).orders.firstIndex { return $0.id == id }
    }
    
    private func indexOfOrderWith(id: Int?) -> Int?
    {
      return type(of: self).orders.firstIndex { return $0.id == id }
    }
}