//
//  OrderTableViewCell.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    let orderNameLabel = UILabel()
    let orderLabel = UILabel()
    let statusLabel = UILabel()
    let statusView = UIButton()
    let stackView = UIStackView()
    var idHolder: Int = 0
    var dateHolder: Date = Date()

    var delegate: OrderStatusSelectionDelegate!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Configure order label
        
        orderNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        orderNameLabel.textColor = UIColor.black
        
        orderLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        orderLabel.textColor = UIColor.black
        
        // Configure status view
        statusView.layer.cornerRadius = 16
        statusView.layer.masksToBounds = true
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        statusView.configuration = .tinted()

       
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusView.addSubview(statusLabel)
        statusView.menu = UIMenu(children: getOrderStatusUIAction())
        
        statusView.showsMenuAsPrimaryAction = true
        statusView.changesSelectionAsPrimaryAction = true

        // Configure stack view
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.addArrangedSubview(orderNameLabel)
        stackView.addArrangedSubview(orderLabel)
        stackView.addArrangedSubview(statusView)

        // Add stack view to cell's content view
        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with order: Orders.FetchOrders.ViewModel.DisplayedOrder) {
        idHolder = order.id
        dateHolder = order.date.getDate()
        orderLabel.text = "Nº - \(order.id)"
        orderNameLabel.text = order.name
        switch order.status {
        case .new:
            statusView.tintColor = UIColor.gray
            statusView.setTitle(OrderStatus.new.rawValue, for: .normal)
            (statusView.menu?.children[0] as? UIAction)?.state = .on
            (statusView.menu?.children[0] as? UIAction)?.title = OrderStatus.new.rawValue
        case .preparing:
            statusView.tintColor = UIColor.orange
            statusView.setTitle(OrderStatus.preparing.rawValue, for: .normal)
            (statusView.menu?.children[1] as? UIAction)?.state = .on
            (statusView.menu?.children[1] as? UIAction)?.title = OrderStatus.preparing.rawValue
        case .ready:
            statusView.tintColor = UIColor.purple
            statusView.setTitle(OrderStatus.ready.rawValue, for: .normal)
            (statusView.menu?.children[2] as? UIAction)?.state = .on
            (statusView.menu?.children[2] as? UIAction)?.title = OrderStatus.ready.rawValue
            statusView.setNeedsLayout()

        case .delivered:
            statusView.tintColor = UIColor.blue
            statusView.setTitle(OrderStatus.delivered.rawValue, for: .normal)
            (statusView.menu?.children[3] as? UIAction)?.state = .on
            (statusView.menu?.children[3] as? UIAction)?.title = OrderStatus.delivered.rawValue
            statusView.setNeedsLayout()
        }
    }
    
    func getOrderStatusUIAction() -> [UIAction] {
        
        let orderStatusSelectionChanged = { (action: UIAction) in
            let orderStatus = OrderStatus(rawValue: action.title)
            self.delegate.orderStatusSelectionChanged(id: self.idHolder, orderStatus: orderStatus ?? .new, date: self.dateHolder)
        }
        
        var orderStatusActions = [UIAction]()
        for orderStatus in OrderStatus.allCases {
            let uiAction = UIAction(title: orderStatus.rawValue, state: .on, handler: orderStatusSelectionChanged)
            orderStatusActions.append(uiAction)
        }
        
        return orderStatusActions
    }
    
}

protocol OrderStatusSelectionDelegate {
    func orderStatusSelectionChanged(id: Int, orderStatus : OrderStatus, date: Date)
}
