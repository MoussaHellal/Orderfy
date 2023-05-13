//
//  OrdersInterractor.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

protocol OrdersBusinessLogic {
    func fetchOrders()
    func createOrder(request: Orders.CreateOrder.Request)
    func updateOrderStatus(request: Orders.UpdateOrder.Request)
    func searchOrder(request: Orders.SearchOrder.Request)
}

protocol OrdersDataStore {
    var orders: [Order]? { get }
}

class ListOrdersInteractor: OrdersBusinessLogic, OrdersDataStore {    
    var presenter: OrdersPresentationLogic?
    
    var ordersWorker = OrdersWorker(ordersStore: OrdersMemoryStore())
    var orders: [Order]?
    
    // MARK: - Fetch orders
    
    func fetchOrders() {
        ordersWorker.fetchOrders { (orders) -> Void in
           self.orders = orders
            let response = Orders.FetchOrders.Response(orders: orders)
            self.presenter?.presentFetchedOrders(response: response)
        }
    }
    
    func createOrder(request: Orders.CreateOrder.Request) {
        
        if orders?.count ?? 0 >= 10  {
            let response = Orders.CreateOrder.Response(order: nil)
            self.presenter?.presentNewAddedOrder(response: response)
            return
        }
        
        let num = self.orders?.first?.id ?? 0
        let id = num + 1
        let order = Order(id: id, name: request.name, date: Date(), status: .new)
        ordersWorker.createOrder(orderToCreate: order) { (order: Order?) in
            self.orders?.insert(order!, at: 0)
            let response = Orders.CreateOrder.Response(order: order)
            self.presenter?.presentNewAddedOrder(response: response)
        }
    }
    
    func updateOrderStatus(request: Orders.UpdateOrder.Request) {
        let ordersPrior = orders?.filter { $0.id < request.id
                                         && $0.status != .delivered
                                        && request.status == .delivered }
        
        let preparingOrder = orders?.filter { $0.status == .preparing}
        
        if ordersPrior?.count ?? 0 > 0  {
            let errorMessage = "You cannot mark an order as Delievered before marking the orders that came before it as Delivered."
            let response = Orders.UpdateOrder.Response(errorMessage: errorMessage, order: nil)
            self.presenter?.presentUpdateOrder(response: response)
            return
        }
        
        if  preparingOrder?.count ?? 0 >= 3 {
            let errorMessage = "You won't be able to mark it as Preparing ⌛ because there are already 3 orders currently in that status."
            let response = Orders.UpdateOrder.Response(errorMessage: errorMessage, order: nil)
            self.presenter?.presentUpdateOrder(response: response)
            return
        }
        
        let orderToUpdate = orders?.filter { $0.id == request.id}.first

        if  orderToUpdate?.status.index ?? 0 > request.status.index {
            let errorMessage = "Once you move an order to the next status, you can't go back"
            let response = Orders.UpdateOrder.Response(errorMessage: errorMessage, order: nil)
            self.presenter?.presentUpdateOrder(response: response)
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
                NotificationCenter.default.post(name: .arhivedOrder, object: nil,userInfo: nil)
            }
        }
    }
    
    func searchOrder(request: Orders.SearchOrder.Request) {
        guard request.id != 0 || !request.name.isEmpty else {
            self.fetchOrders()
            return
        }
        let orders = orders?.filter { $0.id == request.id || $0.name.lowercased().contains(request.name.lowercased())}
        let response = Orders.FetchOrders.Response(orders: orders!)
        self.presenter?.presentFetchedOrders(response: response)
    }
    
}
