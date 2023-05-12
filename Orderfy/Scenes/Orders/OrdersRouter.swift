//
//  OrdersRoute.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

@objc protocol OrdersRoutingLogic {
  func routeToOrderDetails()
}

protocol OrdersDataPassing
{
  var dataStore: OrdersDataStore? { get }
}

class OrdersRouter: NSObject, OrdersRoutingLogic, OrdersDataPassing
{
  weak var viewController: OrdersViewController?
  var dataStore: OrdersDataStore?
  
  // MARK: Routing
  
  func routeToOrderDetails() {
      let destinationVC = OrderDetailsController()
      var destinationDS = destinationVC.router!.dataStore!
      passDataToShowOrder(source: dataStore!, destination: &destinationDS)
      navigateToOrderDetails(source: viewController!, destination: destinationVC)
  }
  
  // MARK: Navigation
  
  func navigateToOrderDetails(source: OrdersViewController, destination: OrderDetailsController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToShowOrder(source: OrdersDataStore, destination: inout OrderDetailsDataStore)
  {
      let selectedRow = viewController?.tableViewController.tableView.indexPathForSelectedRow?.row
    destination.order = source.orders?[selectedRow!]
  }
}
