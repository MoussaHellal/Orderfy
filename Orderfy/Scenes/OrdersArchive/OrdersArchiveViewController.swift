//
//  OrdersArchiveViewController.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

protocol OrdersArchiveDisplayLogic: AnyObject {
  func displayFetchedOrdersArchive(viewModel: OrdersArchive.FetchOrdersArchive.ViewModel)
}

class OrdersArchiveViewController: UIViewController, OrdersArchiveDisplayLogic, UISearchBarDelegate {
    var interactor: OrdersArchiveBusinessLogic?
    var router: (NSObjectProtocol & OrdersArchiveRouter & OrdersArchiveDataPassing)?
    var displayedOrders: [OrdersArchive.FetchOrdersArchive.ViewModel.DisplayedOrderArchive] = []
    
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
        let interactor = ListOrdersArchiveInteractor()
        let presenter = OrdersArchivePresenter()
        let router = OrdersArchiveRouter()
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
        tableViewController.tableView.register(OrderArchiveCell.self, forCellReuseIdentifier: "archiveCell")
        // Change the row height if you want
        tableViewController.tableView.rowHeight = 90
        // This will remove any empty cells that are below your data filled cells
        tableViewController.tableView.tableFooterView = UIView()
        // Set the data source and delegate for the table view controller
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        return tableViewController
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
        createObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArchivedOrders()
    }
    
    func setupConstraints() {
        view.addSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)

        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(tableViewController.view)

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchArchivedOrders() {
      interactor?.fetchOrdersArchive()
    }

    func displayFetchedOrdersArchive(viewModel: OrdersArchive.FetchOrdersArchive.ViewModel) {
        displayedOrders = viewModel.displayedOrders
        tableViewController.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.searchOrderArchive(request: OrdersArchive.SearchOrderArchive.Request(id: Int(searchText) ?? 0, name: searchText))
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleReceivedNewArchivedOrder(notification:)), name: .arhivedOrder, object: nil)
    }
    
    @objc func handleReceivedNewArchivedOrder(notification: NSNotification) {
        self.interactor?.fetchOrdersArchive()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension OrdersArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell", for: indexPath) as! OrderArchiveCell
        let order = displayedOrders[indexPath.row]
        cell.configure(with: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router?.routeToOrderDetails()
    }
}
