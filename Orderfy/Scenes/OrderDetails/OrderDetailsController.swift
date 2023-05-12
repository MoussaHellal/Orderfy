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

class OrderDetailsController: UIViewController, OrderDetailsDisplayLogic {
    var interactor: OrderDetailsBusinessLogic?
    var router: (NSObjectProtocol & OrderDetailsRoutingLogic & OrderDetailsDataPassing)?
    
    let titleLabel = UILabel()
    let label1 = UILabel()
    let label3 = UILabel()
    let stackView = UIStackView()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
      super.init(coder: aDecoder)
      setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view background color
        view.backgroundColor = .white
        
        // Configure the title label
        titleLabel.text = "Order Details"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.title = "Order Details"
        
        // Configure the three labels

        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Configure the stack view
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(label1)
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
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrder()
    }
    
    private func setup() {
      let viewController = self
      let interactor = OrderDetailsInteractor()
      let presenter = OrderDetailsPresenter()
      let router = OrderDetailsRouter()
      viewController.interactor = interactor
      viewController.router = router
      interactor.presenter = presenter
      presenter.viewController = viewController
      router.viewController = viewController
      router.dataStore = interactor
    }
    
    func displayOrderDetails(viewModel: OrderDetails.GetOrder.ViewModel) {
        titleLabel.text = "Order - \(viewModel.displayedOrder.id)"
        label1.text = "Date : " + viewModel.displayedOrder.date
        label3.text = "Status : " + viewModel.displayedOrder.status.rawValue
    }
    
    func getOrder() {
      let request = OrderDetails.GetOrder.Request()
      interactor?.getOrder(request: request)
    }
}
