//
//  OrderViewController.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit


protocol OrdersDisplayLogic: AnyObject {
  func displayFetchedOrders(viewModel: Orders.FetchOrders.ViewModel)
  func displayNewOrder(viewModel: Orders.CreateOrder.ViewModel)
  func displayUpdatedOrder(viewModel: Orders.UpdateOrder.ViewModel)
  func displayOrdersAfterArchiving(viewModel: Orders.UpdateOrder.ViewModel)
}

class OrdersViewController: UIViewController, OrdersDisplayLogic, UISearchBarDelegate {
    var interactor: OrdersBusinessLogic?
    var router: (NSObjectProtocol & OrdersRoutingLogic & OrdersDataPassing)?
    var displayedOrders: [Orders.FetchOrders.ViewModel.DisplayedOrder] = []
    
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
    
    private func setup() {
        let viewController = self
        let interactor = ListOrdersInteractor()
        let presenter = OrdersPresenter()
        let router = OrdersRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private lazy var searchBar : UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    lazy var tableViewController :  UITableViewController = {
        var tableViewController = UITableViewController(style: .plain)
        tableViewController.tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "cell")
        // Change the row height if you want
        tableViewController.tableView.rowHeight = 90
        // This will remove any empty cells that are below your data filled cells
        tableViewController.tableView.tableFooterView = UIView()
        // Set the data source and delegate for the table view controller
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        return tableViewController
    }()
    
    private lazy var createAnOrderButton :  UIButton = {
        let createAnOrderButton = UIButton()
        createAnOrderButton.setTitle("+ Create an Order", for: .normal)
        createAnOrderButton.configuration = .tinted()
        createAnOrderButton.addTarget(self, action: #selector(addCreateOrder), for: .touchUpInside)
        return createAnOrderButton
    }()
    
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrders()
    }
    
    func setupConstraints() {
        view.addSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)

        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(createAnOrderButton)
        stackView.addArrangedSubview(tableViewController.view)

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createAnOrderButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    func fetchOrders() {
      interactor?.fetchOrders()
    }
    
    func displayFetchedOrders(viewModel: Orders.FetchOrders.ViewModel) {
        displayedOrders = viewModel.displayedOrders
        tableViewController.tableView.reloadData()
    }
    
    func displayNewOrder(viewModel: Orders.CreateOrder.ViewModel) {
        guard let order = viewModel.displayedOrder else {
            self.showOrderFailureAlert(title: "Failed", message: "You cannot have more than 10 orders processing ⌛ at once.")
            return
        }
        displayedOrders.insert(Orders.FetchOrders.ViewModel.DisplayedOrder(id: order.id, name: order.name, date: order.date, status: order.status), at: 0)
        tableViewController.tableView.reloadData()
    }
    
    
    func displayUpdatedOrder(viewModel: Orders.UpdateOrder.ViewModel) {
        guard let order = viewModel.displayedOrder else {
            tableViewController.tableView.reloadData()
            self.showOrderFailureAlert(title: "Failed", message: viewModel.errorMessage ?? "unexpected Error Occured")
            return
        }
        let updatedOrderIndex = displayedOrders.firstIndex { return $0.id == order.id }
        displayedOrders[updatedOrderIndex ?? 0].status = order.status
        tableViewController.tableView.reloadData()
    }
    
    func displayOrdersAfterArchiving(viewModel: Orders.UpdateOrder.ViewModel) {
        let order = viewModel.displayedOrder
        let archivedOrderIndex = displayedOrders.firstIndex { return $0.id == order?.id } ?? 0
        displayedOrders.remove(at: archivedOrderIndex)
        tableViewController.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.searchOrder(request: Orders.SearchOrder.Request(id: Int(searchText) ?? 0, name: searchText))
    }
    
    @objc func addCreateOrder(sender: UIButton!) {
        let ac = UIAlertController(title: "Pease Enter Order Name", message: nil, preferredStyle: .alert)
            
        ac.addTextField { $0.placeholder = "order name"
                          $0.addTarget(ac, action: #selector(ac.textDidChangeInLoginAlert), for: .editingChanged) }
        
        let loginAction = UIAlertAction(title: "Submit Order", style: .default) { [unowned self] _ in
            guard let orderName = ac.textFields?[0].text  else { return }
            let request = Orders.CreateOrder.Request(name: orderName)
            self.interactor?.createOrder(request: request)
        }
        ac.addAction(loginAction)
        loginAction.isEnabled = false
        present(ac, animated: true)
    }
}
