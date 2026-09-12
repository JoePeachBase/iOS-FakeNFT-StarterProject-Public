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
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
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
        
        view.backgroundColor = UIColor(resource: .ypWhite)
        setupLayoutAndConstraints()
        bindViewModel()
        viewModel.loadCollections()
        setupNavigationItem()
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            switch state {
            case .initial:
                break
            case .loading:
                self.tableView.allowsSelection = false
                self.tableView.isScrollEnabled = false
                self.tableView.reloadData()
            case .loaded:
                self.tableView.allowsSelection = true
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
            case .failed(let error):
                let errorModel = self.viewModel.makeErrorModel(error)
                self.showError(errorModel)
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
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .sort),
            style: .plain,
            target: self,
            action: #selector(didTapSortButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc
    private func didTapSortButton() {
        let alertController = UIAlertController(title: NSLocalizedString("Catalog.sorting.title", comment: ""), message: nil, preferredStyle: .actionSheet)
        let byName = createAlertAction(title: NSLocalizedString("Catalog.sorting.byName", comment: ""), style: .default) { [weak self] _ in
            self?.viewModel.sort(by: .name)
        }
        let byNFTCount = createAlertAction(title: NSLocalizedString("Catalog.sorting.byCount", comment: ""), style: .default) { [weak self] _ in
            self?.viewModel.sort(by: .nftCount)
        }
        let close = createAlertAction(title: NSLocalizedString("Common.close", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(byName)
        alertController.addAction(byNFTCount)
        alertController.addAction(close)
        
        present(alertController, animated: true)
    }
    
    private func createAlertAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        let alertAction = UIAlertAction(
            title: title,
            style: style,
            handler: handler
        )
        
        return alertAction
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCollections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.reuseIdentifier) as? CatalogCell else { return UITableViewCell()}
        
        switch viewModel.state {
            case .loading:
                cell.configureAsPlaceholder()

            case .loaded:
                guard let cellModel = viewModel.cellModel(at: indexPath.row) else {
                    return UITableViewCell()
                }

                cell.configure(with: cellModel)

            default:
                break
            }

            return cell
    }
}

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let collection = viewModel.collection(at: indexPath.row) else { return }
        
        let detailViewController = CollectionDetailViewController(collection: collection)
        
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}

extension CatalogViewController: ErrorView {
}
