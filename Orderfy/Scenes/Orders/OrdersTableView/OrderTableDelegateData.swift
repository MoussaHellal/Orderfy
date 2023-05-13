//
//  OrderTableDelegateData.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation
import UIKit

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource, OrderStatusSelectionDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableViewCell
        let order = displayedOrders[indexPath.row]
        cell.configure(with: order)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router?.routeToOrderDetails()
    }
    
    func orderStatusSelectionChanged(id: Int, orderStatus : OrderStatus, date: Date) {
        let orderRequest = Orders.UpdateOrder.Request(id: id, status: orderStatus, date: date)
        self.interactor?.updateOrderStatus(request: orderRequest)
    }
}
