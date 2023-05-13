//
//  OrdersArchiveArchiveInterractor.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation

protocol OrdersArchiveBusinessLogic {
    func fetchOrdersArchive()
    func searchOrderArchive(request: OrdersArchive.SearchOrderArchive.Request)
}

protocol OrdersArchiveDataStore {
    var ordersArchive: [Order]? { get }
}

class ListOrdersArchiveInteractor: OrdersArchiveBusinessLogic, OrdersArchiveDataStore {
    var presenter: OrdersArchivePresentationLogic?
    
    var ordersArchiveWorker = OrdersArchiveWorker(OrdersArchiveStore: OrdersMemStore())
    var ordersArchive: [Order]?
    
    // MARK: - Fetch OrdersArchive
    
    func fetchOrdersArchive() {
        ordersArchiveWorker.fetchOrdersArchive { (ordersArchive) -> Void in
           self.ordersArchive = ordersArchive
            let response = OrdersArchive.FetchOrdersArchive.Response(archivedOrders: ordersArchive)
            self.presenter?.presentFetchedOrdersArchive(response: response)
        }
    }
    
    func searchOrderArchive(request: OrdersArchive.SearchOrderArchive.Request) {
        guard request.id != 0 || !request.name.isEmpty else {
            self.fetchOrdersArchive()
            return
        }
        let archivedOrders = ordersArchive?.filter { $0.id == request.id || $0.name.lowercased().contains(request.name.lowercased())}
        let response = OrdersArchive.FetchOrdersArchive.Response(archivedOrders: archivedOrders ?? [])
        self.presenter?.presentFetchedOrdersArchive(response: response)
    }
}
