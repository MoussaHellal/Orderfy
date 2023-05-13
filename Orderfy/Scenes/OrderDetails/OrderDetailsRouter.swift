//
//  OrderRouter.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import Foundation
import UIKit

@objc protocol OrderDetailsRoutingLogic {
  func routeToOrders()
}

protocol OrderDetailsDataPassing {
  var dataStore: OrderDetailsDataStore? { get }
}

class OrderDetailsRouter: NSObject, OrderDetailsRoutingLogic, OrderDetailsDataPassing {
  weak var viewController: OrderDetailsController?
  var dataStore: OrderDetailsDataStore?
  
  // MARK: Routing
  
  func routeToOrders() {
      navigateToOrders(source: viewController!)
  }
  
  // MARK: Navigation
  
  func navigateToOrders(source: OrderDetailsController)
  {
      source.navigationController?.popViewController(animated: true)
  }
}
