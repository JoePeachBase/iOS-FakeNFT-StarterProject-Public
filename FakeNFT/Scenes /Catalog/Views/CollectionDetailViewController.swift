//
//  CollectionDetailViewController.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 10.09.2026.
//

import UIKit

final class CollectionDetailViewController: UIViewController {
    private let collection: NFTCollection
    
    init(collection: NFTCollection) {
        self.collection = collection
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = collection.name
    }
}
