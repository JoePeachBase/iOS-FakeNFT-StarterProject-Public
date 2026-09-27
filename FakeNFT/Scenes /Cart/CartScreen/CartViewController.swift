//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

import UIKit

final class CartViewController: UIViewController, LoadingView {
    lazy var activityIndicator = UIActivityIndicatorView()
    
    private let emptyView: EmptyView = {
        let title = NSLocalizedString("Cart.empty.title", comment: "")
        let view = EmptyView(title: title)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isHidden = true
        return table
    }()
    private let checkoutView: CheckoutBottomView = {
        let checkout = CheckoutBottomView()
        checkout.translatesAutoresizingMaskIntoConstraints = false
        checkout.isHidden = true
        return checkout
    }()
    private var viewModel: CartViewModelProtocol
    private var paymentAssembly: PaymentAssembly
    
    // MARK: - Init
    init(
        viewModel: CartViewModelProtocol,
        paymentAssembly: PaymentAssembly
    ) {
        self.viewModel = viewModel
        self.paymentAssembly = paymentAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateCheckoutBottomView()
        viewModel.fetchOrder()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        setupNavBar()
        setupView()
        setupTableView()
        setupViewModel()
    }
    
    private func setupNavBar() {
        let filtersImage = UIImage(resource: .filters)
        let filtersAction = UIAction { [weak self] _ in
            self?.openFiltersSheet()
        }
        let filtersButton = UIBarButtonItem(
            image: filtersImage,
            primaryAction: filtersAction
        )
        
        navigationItem.rightBarButtonItem = filtersButton
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(activityIndicator)
        view.addSubview(tableView)
        view.addSubview(checkoutView)
        view.addSubview(emptyView)
        
        checkoutView.onCheckoutButtonTapped = { [weak self] in
            guard let self else { return }
            
            let paymentViewController = paymentAssembly.build()
            navigationController?.pushViewController(paymentViewController, animated: true)
        }
        
        activityIndicator.constraintCenters(to: view)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: checkoutView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            checkoutView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            checkoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor),
            
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(CartItemCell.self)
    }
    
    private func setupViewModel() {
        viewModel.state.bindListener { [weak self] state in
            self?.listenState(state)
        }
        viewModel.event.bindListener { [weak self] event in
            guard let self, let event else { return }
            listenEvent(event)
        }
    }
    
    private func listenState(_ state: ViewState<OrderModel>) {
        let shouldShowContent = state.isSuccess && !state.isEmpty
        
        tableView.isHidden = !shouldShowContent
        checkoutView.isHidden = !shouldShowContent
        emptyView.isHidden = !state.isEmpty
        navigationController?.navigationBar.isHidden = state.isFailure || !shouldShowContent
        
        updateCheckoutBottomView()
        
        if state.isLoading {
            showLoading()
        } else {
            hideLoading()
        }
    }
    
    private func listenEvent(_ event: CartEvent) {
        switch event {
        case .dataLoaded, .orderSorted:
            tableView.reloadData()
        default:
            break
        }
    }
    
    private func openFiltersSheet() {
        let actionSheet = makeFiltersActionSheet()
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func makeFiltersActionSheet() -> UIAlertController {
        let title = NSLocalizedString("Cart.filters.title", comment: "")
        let actionSheet = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        CartSortOption.allCases.forEach { sortOption in
            let isCurrent = sortOption == viewModel.currentSortOption
            let actionTitle = isCurrent ? "\(sortOption.title)  ✓" : sortOption.title
            
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
                self?.viewModel.changeSortOption(sortOption)
            }
            actionSheet.addAction(action)
        }
        
        let closeTitle = NSLocalizedString(
            "Cart.filters.action.close",
            comment: ""
        )
        let closeAction = UIAlertAction(
            title: closeTitle,
            style: .cancel,
            handler: nil
        )
        actionSheet.addAction(closeAction)
        
        return actionSheet
    }
    
    private func deleteNft(at indexPath: IndexPath) {
        guard indexPath.row < viewModel.nfts.count else { return }
        let nftToDelete = viewModel.nfts[indexPath.row]
        
        tableView.performBatchUpdates {
            viewModel.deleteNft(with: nftToDelete.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func updateCheckoutBottomView() {
        checkoutView.configure(
            countText: viewModel.totalCountText,
            priceText: viewModel.totalSumText
        )
    }
}

// MARK: - UITableViewDataSource extension
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartItemCell = tableView.dequeueReusableCell()
        let nft = viewModel.nfts[indexPath.row]
        
        cell.configure(
            with: nft.title,
            price: nft.formattedPrice,
            rating: nft.rating,
            imageURL: nft.imageURL
        )
        cell.onCartButtonTap = { [weak self] in
            guard let actualIndexPath = self?.tableView.indexPath(for: cell) else {
                return
            }
            self?.showDeleteMenu(actualIndexPath)
        }
        
        return cell
    }
    
    private func showDeleteMenu(_ indexPath: IndexPath) {
        let menuViewController = CartDeleteItemMenuViewController()
        let text = NSLocalizedString("Cart.menu.delete.title", comment: "")
        
        menuViewController
            .configure(imageResource: ImageResource.deleteAlert, text: text)
        menuViewController.onDeleteButtonTap = { [weak self] in
            self?.deleteNft(at: indexPath)
        }
        
        menuViewController.modalPresentationStyle = .overFullScreen
        menuViewController.modalTransitionStyle = .crossDissolve
        
        present(menuViewController, animated: true)
    }
}
