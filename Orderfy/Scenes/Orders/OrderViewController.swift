//
//  OrderViewController.swift
//  Orderfy
//
//  Created by Moussa on 10/5/2023.
//

import UIKit

class OrdersViewController: UIViewController {

    let searchBar = UISearchBar()
    let titleLabel = UILabel()

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
    }

}
