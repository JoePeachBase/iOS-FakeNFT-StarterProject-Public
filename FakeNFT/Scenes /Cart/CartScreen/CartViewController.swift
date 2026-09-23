//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

import UIKit

final class CartViewController: UIViewController {
    // MARK: - Private properties
    private let viewModel = CartViewModel()
    private let filtersService: CartSortOptionServiceProtocol = CartSortOptionService()
    
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
        return table
    }()
    private let checkoutView: CheckoutBottomView = {
        let checkout = CheckoutBottomView()
        checkout.translatesAutoresizingMaskIntoConstraints = false
        return checkout
    }()
    
    private var nfts: [NftModel] = [
        .init(
            title: "Что-то",
            imageURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
            rating: 4,
            formattedPrice: "7 ETH",
            price: 7
        ),
        .init(
            title: "April",
            imageURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
            rating: 1,
            formattedPrice: "2 ETH",
            price: 2
        ),
        .init(
            title: "Greena",
            imageURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
            rating: 0,
            formattedPrice: "3 ETH",
            price: 3
        ),
        .init(
            title: "Spring",
            imageURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
            rating: 5,
            formattedPrice: "4 ETH",
            price: 4
        )
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateCheckoutBottomView()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        setupNavBar()
        setupView()
        setupTableView()
        viewModel.state.bindListener { [weak self] state in
            self?.listenState(state)
        }
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
        view.addSubview(tableView)
        view.addSubview(checkoutView)
        view.addSubview(emptyView)
        
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
    
    private func listenState(_ state: ViewState<[NftModel]>) {
        // TODO Добавить обработку стейта
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
        
        let currentFilter = filtersService.loadSortOption()
        
        CartSortOption.allCases.forEach { sortOption in
            let isCurrent = sortOption == currentFilter
            let actionTitle = isCurrent ? "\(sortOption.title)  ✓" : sortOption.title
            
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
                self?.handleFilterSelection(sortOption)
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
    
    private func handleFilterSelection(_ sortOption: CartSortOption) {
        filtersService.saveSortOption(sortOption)
        nfts = sort(nfts, with: sortOption)
        
        UIView.transition(
            with: tableView,
            duration: 0.2,
            options: .transitionCrossDissolve
        ) {
            self.tableView.reloadData()
        }
    }
    
    private func deleteNft(at indexPath: IndexPath) {
        guard indexPath.row < nfts.count else { return }
        
        tableView.performBatchUpdates {
            nfts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } completion: { [weak self] _ in
            guard let self else { return }
            
            if nfts.isEmpty {
                emptyView.isHidden = false
            }
            updateCheckoutBottomView()
        }
    }
    
    private func updateCheckoutBottomView() {
        let totalCount = nfts.count
        let totalSum = nfts.reduce(0) { $0 + $1.price }
        
        let countText = "\(totalCount) NFT"
        let priceText = "\(totalSum) ETH"
        
        checkoutView.configure(
            countText: countText,
            priceText: priceText
        )
        checkoutView.isHidden = nfts.isEmpty
    }
}

// MARK: - UITableViewDataSource extension
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartItemCell = tableView.dequeueReusableCell()
        let nft = nfts[indexPath.row]
        
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
    
    private func configureCell() {
        
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

// MARK: - NFT sorting by filter
extension CartViewController {
    func sort(_ nfts: [NftModel], with sortOption: CartSortOption) -> [NftModel] {
        switch sortOption {
        case .title:
            return nfts
                .sorted {
                    $0.title.localizedCompare($1.title) == .orderedAscending
                }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .price:
            return nfts.sorted { $0.price < $1.price }
        }
    }
}
