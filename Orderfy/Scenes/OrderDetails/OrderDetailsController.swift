//
//  OrderDetailsController.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

protocol OrderDetailsDisplayLogic: AnyObject
{
    func displayOrderDetails(viewModel: OrderDetails.GetOrder.ViewModel)
}

class OrderDetailsController: UIViewController {
    
    var interactor: OrderDetailsBusinessLogic?
    var router: (NSObjectProtocol & OrderDetailsRoutingLogic & OrderDetailsDataPassing)?
    
    let titleLabel = UILabel()
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view background color
        view.backgroundColor = .white
        
        // Configure the title label
        titleLabel.text = "Order Details"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Configure the three labels
        label1.text = "Label 1"
        label2.text = "Label 2"
        label3.text = "Label 3"
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the stack view
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(label3)
        view.addSubview(stackView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
}
