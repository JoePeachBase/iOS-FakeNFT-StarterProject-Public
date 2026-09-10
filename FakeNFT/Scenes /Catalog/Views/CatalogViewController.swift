//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 10.09.2026.
//

import UIKit

final class CatalogViewController: UIViewController {
    private let viewModel: CatalogViewModel
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        return tableView
    }()
    
    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayoutAndConstraints()
        bindViewModel()
        viewModel.loadCollections()
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .initial:
                break
            case .loading:
                break
            case .loaded:
                self?.tableView.reloadData()
            case .failed(let error):
                print(error)
            }
            
        }
    }
    
    private func setupLayoutAndConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ]
        )
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCollections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        guard let collection = viewModel.collection(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = collection.name
        cell.detailTextLabel?.text = "\(collection.nftCount) NFT"
        return cell
    }
}
