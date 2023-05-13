//
//  OrdersMemStore.swift
//  Orderfy
//
//  Created by Moussa on 12/5/2023.
//

import Foundation

class OrdersMemoryStore: OrdersStoreProtocol {
    // MARK: - Data
    
    static var orders = [Order]()
    static var archivedOrders = [Order]()

    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void) {
     completionHandler { return type(of: self).orders.reversed() }
    }
    
    func fetchArchivedOrders(completionHandler: @escaping (() throws -> [Order]) -> Void) {
     completionHandler { return type(of: self).archivedOrders }
    }
    
    func fetchOrder(id: Int, completionHandler: @escaping (() throws -> Order?) -> Void) {
      if let index = indexOfOrderWith(id: id) {
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
        if let index = indexOfOrderWith(id: id) {
        type(of: self).orders[index].status = status
          let order = type(of: self).orders[index]
          completionHandler { return order }
        } else {
          completionHandler { throw OrdersStoreError.CannotUpdate("Cannot fetch order with \(String(describing: id)) to update")
          }
        }
    }
    
    func archiveOrder(id: Int, completionHandler: @escaping (() throws -> Order?) -> Void) {
        if let index = indexOfOrderWith(id: id) {
          let orderToArchive = type(of: self).orders[index]
          type(of: self).orders.remove(at: index)
          type(of: self).archivedOrders.insert(orderToArchive, at: 0)
          completionHandler { return orderToArchive }
        } else {
          completionHandler { throw OrdersStoreError.CannotUpdate("Cannot fetch order with \(String(describing: id)) to archive")
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
