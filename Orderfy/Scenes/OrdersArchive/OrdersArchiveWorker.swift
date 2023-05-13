//
//  OrdersArchiveArchiveWorker.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation


class OrdersArchiveWorker {
  var OrdersArchiveStore: OrdersStoreProtocol
  
  init(OrdersArchiveStore: OrdersStoreProtocol) {
    self.OrdersArchiveStore = OrdersArchiveStore
  }
  
    func fetchOrdersArchive(completionHandler: @escaping ([Order]) -> Void) {
        OrdersArchiveStore.fetchArchivedOrders { (ordersArchive: () throws -> [Order]) -> Void in
        do {
          let ordersArchive = try ordersArchive()
          DispatchQueue.main.async {
            completionHandler(ordersArchive)
          }
        } catch {
          DispatchQueue.main.async {
            completionHandler([])
          }
        }
      }
    }
}
