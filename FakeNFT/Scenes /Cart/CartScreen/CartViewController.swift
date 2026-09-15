//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

import UIKit

final class CartViewController: UIViewController {
    private let viewModel = CartViewModel()
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private var nfts: [Nft] = []
    
    override func viewDidLoad() {
        viewModel.state.bindListener(listenState)
    }
    
    private func listenState(_ state: ViewState<[Nft]>) {
        // TODO Добавить обработку стейта
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
