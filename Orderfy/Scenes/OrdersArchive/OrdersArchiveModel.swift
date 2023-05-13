//
//  OrdersArchiveModel.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation

enum OrdersArchive
{
    // MARK: Use cases
    enum FetchOrdersArchive
    {
        struct Request
        {
        }
        struct Response
        {
            var archivedOrders: [Order]
        }
        struct ViewModel
        {
            struct DisplayedOrderArchive
            {
                var id: Int
                var name: String
                var date: String
                var status: OrderStatus
            }
            var displayedOrders: [DisplayedOrderArchive]
        }
    }
    enum SearchOrderArchive
    {
        struct Request
        {
            var id: Int
            var name: String
        }
        struct Response
        {
            var archivedOrders: Order?
        }
        struct ViewModel
        {
            struct DisplayedOrderArchive
            {
                var id: Int
                var name: String
                var date: String
                var status: OrderStatus
            }
            var displayedOrders: [DisplayedOrderArchive]
        }
    }
}
