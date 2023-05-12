//
//  OrderTableViewCell.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    let orderLabel = UILabel()
    let statusLabel = UILabel()
    let statusView = UIView()
    let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Configure order label
        orderLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        orderLabel.textColor = UIColor.black

        // Configure status view
        statusView.layer.cornerRadius = 5
        statusView.layer.masksToBounds = true
        statusView.frame.size = CGSize(width: 75, height: 50)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(statusLabel)
        
        // Configure stack view
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
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
        orderLabel.text = "Order - \(order.id)"

        switch order.status {
        case .new:
            statusView.backgroundColor = UIColor.blue
            statusLabel.text = OrderStatus.new.rawValue
        case .preparing:
            statusView.backgroundColor = UIColor.orange
            statusLabel.text = OrderStatus.preparing.rawValue
        case .ready:
            statusView.backgroundColor = UIColor.purple
            statusLabel.text = OrderStatus.ready.rawValue
        case .delivered:
            statusView.backgroundColor = UIColor.green
            statusLabel.text = OrderStatus.delivered.rawValue

        }
    }
}
