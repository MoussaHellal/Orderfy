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
    
    private lazy var titleLabel: UILabel =  {
        return UILabel().defaultLabelSpecs()
    }()
    
    private lazy var dateLabel : UILabel =  {
        return UILabel().defaultLabelSpecs()
    }()
    
    private lazy var statusLabel : UILabel =  {
        return UILabel().defaultLabelSpecs()
    }()
    
    private lazy var stackView : UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var slider : UISlider =  {
        UISlider()
    }()
    
    private lazy var statusHolder: String? = nil
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        view.backgroundColor = .white
        self.title = "Order Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrder()
        setUIandConstraints()
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
    
    private func setUIandConstraints() {
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(statusLabel)
        
        setStatusStackViews()
        
        view.addSubview(stackView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 400),
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            dateLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            statusLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    func displayOrderDetails(viewModel: OrderDetails.GetOrder.ViewModel) {
        titleLabel.text = "Order Nº : \(viewModel.displayedOrder.id)"
        dateLabel.text = "" + viewModel.displayedOrder.date
        statusLabel.text = "Current Status"
        statusHolder = viewModel.displayedOrder.status.rawValue
    }
    
    private func getOrder() {
      let request = OrderDetails.GetOrder.Request()
      interactor?.getOrder(request: request)
    }
    
    private func setStatusStackViews() {
        for status in OrderStatus.allCases {
            let orderStatusLabel = UILabel().defaultLabelSpecs()
            orderStatusLabel.text = status.rawValue
            orderStatusLabel.translatesAutoresizingMaskIntoConstraints = false
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.addArrangedSubview(orderStatusLabel)
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            
            for _ in 0..<1 {
                let graphicLabel = UILabel().defaultLabelSpecs()
                graphicLabel.text = status.graphicRespresentive
                graphicLabel.translatesAutoresizingMaskIntoConstraints = false
                
                rowStackView.addArrangedSubview(graphicLabel)
                if statusHolder == status.rawValue {
                    graphicLabel.backgroundColor = status.color
                    orderStatusLabel.backgroundColor = status.color
                    orderStatusLabel.textColor = .white
                }
            }
            
            stackView.addArrangedSubview(rowStackView)
            rowStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
}
