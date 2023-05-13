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

class OrdersViewController: UIViewController, OrdersDisplayLogic, OrderStatusSelectionDelegate {
    var interactor: OrdersBusinessLogic?
    var router: (NSObjectProtocol & OrdersRoutingLogic & OrdersDataPassing)?


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
    
    let searchBar = UISearchBar()
    let titleLabel = UILabel()
    let tableViewController = UITableViewController(style: .plain)
    let createAnOrderButton = UIButton()
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view background color
        view.backgroundColor = .white

        // Configure the search bar
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)

        // Set up constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrders()
    }
    
    var displayedOrders: [Orders.FetchOrders.ViewModel.DisplayedOrder] = []

    func fetchOrders() {
      let request = Orders.FetchOrders.Request()
      interactor?.fetchOrders(request: request)
    }
    
    func displayFetchedOrders(viewModel: Orders.FetchOrders.ViewModel) {
        displayedOrders = viewModel.displayedOrders
        tableViewController.tableView.reloadData()
    }
    
    func displayNewOrder(viewModel: Orders.CreateOrder.ViewModel) {
        let order = viewModel.displayedOrder
        displayedOrders.insert(Orders.FetchOrders.ViewModel.DisplayedOrder(id: order.id, name: order.name, date: order.date, status: order.status), at: 0)
        tableViewController.tableView.reloadData()
    }
    
    func displayUpdatedOrder(viewModel: Orders.UpdateOrder.ViewModel) {
        let order = viewModel.displayedOrder
        var updatedOrderIndex = displayedOrders.firstIndex { return $0.id == order.id }
        displayedOrders[updatedOrderIndex ?? 0].status = order.status
        print(displayedOrders)
        tableViewController.tableView.reloadData()
    }
    
    func displayOrdersAfterArchiving(viewModel: Orders.UpdateOrder.ViewModel) {
        let order = viewModel.displayedOrder
        let archivedOrderIndex = displayedOrders.firstIndex { return $0.id == order.id } ?? 0
        displayedOrders.remove(at: archivedOrderIndex)
        tableViewController.tableView.reloadData()
    }
    
    func setTableView() {
        tableViewController.tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "cell")
        // Change the row height if you want
        tableViewController.tableView.rowHeight = 90
        // This will remove any empty cells that are below your data filled cells
        tableViewController.tableView.tableFooterView = UIView()
        
        // Set the data source and delegate for the table view controller
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        
        // Add the table view controller's view as a subview
       // addChild(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)
        
        // Set up constraints
        tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            tableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill

        createAnOrderButton.setTitle("+ Create an Order", for: .normal)
        createAnOrderButton.backgroundColor = .blue
        createAnOrderButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        createAnOrderButton.addTarget(self, action: #selector(addCreateOrder), for: .touchUpInside)

        stackView.addArrangedSubview(createAnOrderButton)
        stackView.addArrangedSubview(tableViewController.view)

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
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
    
    @objc func addCreateOrder(sender: UIButton!) {
        let ac = UIAlertController(title: "Pease Enter Order Name", message: nil, preferredStyle: .alert)
        
        ac.addTextField {
            $0.placeholder = "order name"
            $0.addTarget(ac, action: #selector(ac.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        let loginAction = UIAlertAction(title: "Submit Order", style: .default) { [unowned self] _ in
            guard let orderName = ac.textFields?[0].text  else { return } // Should never happen
            
            let num = self.displayedOrders.first!.id
            let id = num + 1
            let request = Orders.CreateOrder.Request(id: id, name: orderName)
            self.interactor?.createOrder(request: request)
        }

        ac.addAction(loginAction)
        loginAction.isEnabled = false
        present(ac, animated: true)
    }
    
    private func showOrderFailureAlert(title: String, message: String) {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      showDetailViewController(alertController, sender: nil)
    }
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableViewCell

        let order = displayedOrders[indexPath.row]
        cell.configure(with: order)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router?.routeToOrderDetails()
    }
    
    func orderStatusSelectionChanged(id: Int, orderStatus : OrderStatus, date: Date) {
        let orderRequest = Orders.UpdateOrder.Request(id: id, status: orderStatus, date: date)
        self.interactor?.updateOrderStatus(request: orderRequest, completion: { [weak self] message, success  in
            guard let self = self else { return }
            guard success == true else {
                DispatchQueue.main.async {
                    self.tableViewController.tableView.reloadData()
                    self.showOrderFailureAlert(title: "Failed", message: message)
                }
                return
            }
        })
    }
    
    
}
