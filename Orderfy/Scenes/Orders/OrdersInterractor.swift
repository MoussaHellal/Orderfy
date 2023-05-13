//
//  OrdersInterractor.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

protocol OrdersBusinessLogic {
    func fetchOrders(request: Orders.FetchOrders.Request)
    func createOrder(request: Orders.CreateOrder.Request)
    func updateOrderStatus(request: Orders.UpdateOrder.Request, completion: @escaping (String, Bool) -> ())
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
    
    func createOrder(request: Orders.CreateOrder.Request) {
        let order = Order(id: request.id, name: request.name, date: Date(), status: .new)
        ordersWorker.createOrder(orderToCreate: order) { (order: Order?) in
            self.orders?.insert(order!, at: 0)
            let response = Orders.CreateOrder.Response(order: order)
            self.presenter?.presentNewAddedOrder(response: response)
        }
    }
    
    func updateOrderStatus(request: Orders.UpdateOrder.Request, completion: @escaping (String, Bool) -> ()) {
        let ordersPrior = orders?.filter { $0.id < request.id
                                         && $0.status != .delivered
                                        && request.status == .delivered }
        
        let preparingOrder = orders?.filter { $0.status == .preparing}
        
        if ordersPrior?.count ?? 0 > 0  {
            completion("You cannot mark an order as Delievered before marking the orders that came before it as Delivered.", false)
            return
        }
        
        if  preparingOrder?.count ?? 0 >= 3 {
            completion("You won't be able to mark it as Preparing ⌛ because there are already 3 orders currently in that status. ", false)
            return
        }

        ordersWorker.updateOrder(id: request.id, status: request.status) { (order: Order?) in
            let response = Orders.UpdateOrder.Response(order: order)
            self.presenter?.presentUpdateOrder(response: response)
            let orderToUpdateIndex = self.orders?.firstIndex {order?.id == $0.id}
            self.orders?[orderToUpdateIndex ?? 0] = order!
            
            if request.status == .delivered {
                self.archiveOrder(request: request)
            }
            completion("Success", true)
        }
    }
    
    func archiveOrder(request: Orders.UpdateOrder.Request) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
            guard let self = self else {return}
            self.ordersWorker.archiveOrder(id: request.id) { (order: Order?) in
                let response = Orders.UpdateOrder.Response(order: order)
                let orderToRemoveIndex = self.orders?.firstIndex {order?.id == $0.id}
                self.orders?.remove(at: orderToRemoveIndex ?? 0)
                self.presenter?.presentOrdersAfterArchiving(response: response)
            }
        }
    }
}
