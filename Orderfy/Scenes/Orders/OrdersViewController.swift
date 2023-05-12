//
//  OrderViewController.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit


protocol OrdersDisplayLogic: AnyObject {
  func displayFetchedOrders(viewModel: Orders.FetchOrders.ViewModel)
}

class OrdersViewController: UIViewController, OrdersDisplayLogic {
    
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
        
        tableViewController.tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "cell")
               // Change the row height if you want
        tableViewController.tableView.rowHeight = 75
               // This will remove any empty cells that are below your data filled cells
        tableViewController.tableView.tableFooterView = UIView()
        
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
        print(displayedOrders)
        tableViewController.tableView.reloadData()
    }
    
    func setTableView() {
        // Set the data source and delegate for the table view controller
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        
        // Add the table view controller's view as a subview
        addChild(tableViewController)
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
    
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableViewCell

        let order = displayedOrders[indexPath.row]
        cell.configure(with: order)
        
        return cell
    }
}
