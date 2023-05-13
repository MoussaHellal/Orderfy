//
//  OrdersModel.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

enum Orders
{
    // MARK: Use cases
    
    enum FetchOrders
    {
        struct Request
        {
        }
        struct Response
        {
            var orders: [Order]
        }
        struct ViewModel
        {
            struct DisplayedOrder
            {
                var id: Int
                var name: String
                var date: String
                var status: OrderStatus
            }
            var displayedOrders: [DisplayedOrder]
        }
    }
    
    enum CreateOrder
    {
        struct Request
        {
            var id: Int
            var name: String
        }
        struct Response
        {
            var order: Order?
        }
        struct ViewModel
        {
            struct DisplayedOrder
            {
                var id: Int
                var name: String
                var date: String
                var status: OrderStatus
            }
            var displayedOrder: DisplayedOrder
        }
    }
    
    enum UpdateOrder
    {
        struct Request
        {
            var id: Int
            var status: OrderStatus
            var date: Date
        }
        struct Response
        {
            var order: Order?
        }
        struct ViewModel
        {
            struct DisplayedOrder
            {
                var id: Int
                var name: String
                var date: String
                var status: OrderStatus
            }
            var displayedOrder: DisplayedOrder
        }
    }
}
