//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

import UIKit

final class CartViewController: UIViewController {
    
    private let viewModel = CartViewModel()
    
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
    
    private var nfts: [NftUiModel] = [
        .init(
            title: "Что-то",
            imageURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
            rating: 4,
            price: "155 ETH"
        ),
        .init(
            title: "Что-то",
            imageURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
            rating: 1,
            price: "155 ETH"
        ),
        .init(
            title: "Что-то",
            imageURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
            rating: 0,
            price: "155 ETH"
        ),
        .init(
            title: "Что-то",
            imageURL: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
            rating: 5,
            price: "155 ETH"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupNavBar()
        setupView()
        setupTableView()
        viewModel.state.bindListener(listenState)
    }
    
    private func setupNavBar() {
        let filtersImage = UIImage(resource: .filters)
        
        let filtersAction = UIAction { [weak self] _ in
            // TODO Добавить фильтры
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
        
        let buttonTitle = NSLocalizedString("Cart.button.payment.title", comment: "")
        checkoutView.configure(countText: "4 NFTs", priceText: "5 ETH", buttonTitle: buttonTitle)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: checkoutView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            checkoutView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            checkoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
    }
    
    private func listenState(_ state: ViewState<[NftUiModel]>) {
        // TODO Добавить обработку стейта
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier) as? CartItemCell else {
            return UITableViewCell()
        }
        let nft = nfts[indexPath.row]
        cell.configure(with: nft.title, price: nft.price, imageUrlString: nft.imageURL, rating: nft.rating)
        
        return cell
    }
}
