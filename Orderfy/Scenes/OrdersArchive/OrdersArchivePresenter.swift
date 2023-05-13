//
//  OrdersArchivePresenter.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation
import UIKit

protocol OrdersArchivePresentationLogic {
  func presentFetchedOrdersArchive(response: OrdersArchive.FetchOrdersArchive.Response)

}

class OrdersArchivePresenter: OrdersArchivePresentationLogic {
  weak var viewController: OrdersArchiveDisplayLogic?
  
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    return dateFormatter
  }()
  
  let currencyFormatter: NumberFormatter = {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    return currencyFormatter
  }()
  
  // MARK: - Fetch OrdersArchive
  
  func presentFetchedOrdersArchive(response: OrdersArchive.FetchOrdersArchive.Response) {
    var displayedOrdersArchive: [OrdersArchive.FetchOrdersArchive.ViewModel.DisplayedOrderArchive] = []
    for order in response.archivedOrders {
      let date = dateFormatter.string(from: order.date)
        let displayedOrder = OrdersArchive.FetchOrdersArchive.ViewModel.DisplayedOrderArchive(id: order.id, name: order.name, date: date, status: order.status)
      displayedOrdersArchive.append(displayedOrder)
    }
      let viewModel = OrdersArchive.FetchOrdersArchive.ViewModel(displayedOrders: displayedOrdersArchive)
    viewController?.displayFetchedOrdersArchive(viewModel: viewModel)
  }
}
