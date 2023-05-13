//
//  OrderArchiveCell.swift
//  Orderfy
//
//  Created by Moussa on 13/5/2023.
//

import Foundation
import UIKit

class OrderArchiveCell: UITableViewCell {
    private lazy var orderNameLabel: UILabel = {
        let orderNameLabel = UILabel()
        orderNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        orderNameLabel.textColor = UIColor.black
        return orderNameLabel
    }()
    
    private lazy var orderLabel: UILabel = {
        UILabel()
    }()
    
    private lazy var orderCounter: UILabel = {
        UILabel()
    }()
    
    private lazy var statusButton: UIButton = {
        let statusButton = UIButton()
        statusButton.layer.cornerRadius = 16
        statusButton.layer.masksToBounds = true
        statusButton.configuration = .tinted()
        return statusButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var idHolder: Int = {
        return 0
    }()
    
    private lazy var dateHolder: Date = {
         Date()
    }()

    var seconds = 15
    var timer = Timer()
    var isTimeRunning = false
    
    var delegate: OrderStatusSelectionDelegate!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        orderLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        orderLabel.textColor = UIColor.black
        
        // Configure status view
        statusButton.translatesAutoresizingMaskIntoConstraints = false

        orderCounter.textColor = .black
        orderCounter.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        orderCounter.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(orderNameLabel)
        stackView.addArrangedSubview(orderCounter)
        stackView.addArrangedSubview(orderLabel)
        stackView.addArrangedSubview(statusButton)

        // Add stack view to cell's content view
        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            statusButton.widthAnchor.constraint(equalToConstant: 120),
            statusButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with order: OrdersArchive.FetchOrdersArchive.ViewModel.DisplayedOrderArchive) {
        idHolder = order.id
        dateHolder = order.date.getDate()
        orderLabel.text = "Nº : \(order.id)"
        orderNameLabel.text = order.name
        switch order.status {
        case .new:
            statusButton.tintColor = UIColor.gray
            statusButton.setTitle(OrderStatus.new.rawValue, for: .normal)
        case .preparing:
            statusButton.tintColor = UIColor.orange
            statusButton.setTitle(OrderStatus.preparing.rawValue, for: .normal)
        case .ready:
            statusButton.tintColor = UIColor.purple
            statusButton.setTitle(OrderStatus.ready.rawValue, for: .normal)
        case .delivered:
            statusButton.tintColor = UIColor.blue
            statusButton.setTitle(OrderStatus.delivered.rawValue, for: .normal)
        }
    }
}
