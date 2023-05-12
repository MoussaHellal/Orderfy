//
//  OrdersWorker.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import Foundation

class OrdersWorker {
  var ordersStore: OrdersStoreProtocol
  
  init(ordersStore: OrdersStoreProtocol) {
    self.ordersStore = ordersStore
  }
  
    func fetchOrders(completionHandler: @escaping ([Order]) -> Void)
    {
     
//        ordersStore.fetchOrders { ordersResult in
//
//            switch ordersResult {
//            case .Success(result: let orders) :
//                completionHandler(orders)
//            case .Failure(let error):
//                completionHandler([])
//        }
        
        
        ordersStore.fetchOrders { (orders: () throws -> [Order]) -> Void in
        do {
          let orders = try orders()
          DispatchQueue.main.async {
            completionHandler(orders)
          }
        } catch {
          DispatchQueue.main.async {
            completionHandler([])
          }
        }
      }
    }
//
//  func createOrder(orderToCreate: Order, completionHandler: @escaping (Order?) -> Void) {
//    ordersStore.createOrder(orderToCreate: orderToCreate) { (order: () throws -> Order?) -> Void in
//      do {
//        let order = try order()
//        DispatchQueue.main.async {
//          completionHandler(order)
//        }
//      } catch {
//        DispatchQueue.main.async {
//          completionHandler(nil)
//        }
//      }
//    }
//  }
//
//  func updateOrder(orderToUpdate: Order, completionHandler: @escaping (Order?) -> Void) {
//    ordersStore.updateOrder(orderToUpdate: orderToUpdate) { (order: () throws -> Order?) in
//      do {
//        let order = try order()
//        DispatchQueue.main.async {
//          completionHandler(order)
//        }
//      } catch {
//        DispatchQueue.main.async {
//          completionHandler(nil)
//        }
//      }
//    }
//  }
}

// MARK: - Orders store API

protocol OrdersStoreProtocol {

  
    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void)
    func fetchOrder(id: Int, completionHandler: @escaping (() throws -> Order?) -> Void)
}

// MARK: - Orders store CRUD operation results

typealias OrdersStoreFetchOrdersCompletionHandler = (OrdersStoreResult<[Order]>) -> Void
typealias OrdersStoreFetchOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void

enum OrdersStoreResult<U> {
  case Success(result: U)
  case Failure(error: OrdersStoreError)
}

// MARK: - Orders store CRUD operation errors

enum OrdersStoreError: Equatable, Error {
  case CannotFetch(String)
  case CannotCreate(String)
  case CannotUpdate(String)
  case CannotDelete(String)
}

func ==(lhs: OrdersStoreError, rhs: OrdersStoreError) -> Bool {
  switch (lhs, rhs) {
  case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
  case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
  case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
  case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
  default: return false
  }
}
