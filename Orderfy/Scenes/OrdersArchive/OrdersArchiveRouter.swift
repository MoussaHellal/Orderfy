//
//  OrdersArchiveArchiveRouter.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation
import UIKit

@objc protocol OrdersArchiveRoutingLogic {
  func routeToOrderDetails()
}

protocol OrdersArchiveDataPassing
{
  var dataStore: OrdersArchiveDataStore? { get }
}

class OrdersArchiveRouter: NSObject, OrdersArchiveRoutingLogic, OrdersArchiveDataPassing
{
  weak var viewController: OrdersArchiveViewController?
  var dataStore: OrdersArchiveDataStore?
  
  // MARK: Routing
  
  func routeToOrderDetails() {
      let destinationVC = OrderDetailsController()
      var destinationDS = destinationVC.router!.dataStore!
      passDataToShowOrder(source: dataStore!, destination: &destinationDS)
      navigateToOrderDetails(source: viewController!, destination: destinationVC)
  }
  
  // MARK: Navigation
  
  func navigateToOrderDetails(source: OrdersArchiveViewController, destination: OrderDetailsController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToShowOrder(source: OrdersArchiveDataStore, destination: inout OrderDetailsDataStore)
  {
      let selectedRow = viewController?.tableViewController.tableView.indexPathForSelectedRow?.row
      destination.order = source.ordersArchive?[selectedRow!]
  }
}
