//
//  CollectionDetailAssembly.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 13.09.2026.
//

import UIKit

final class CollectionDetailAssembly {
    
    private let serviceAssembly: ServicesAssembly
    
    init(serviceAssembly: ServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func build(with collection: NFTCollection) -> UIViewController {
        let viewModel = CollectionDetailViewModel(
            collection: collection,
            nftService: serviceAssembly.nftService
        )
        
        let nftDetailAssembly = NftDetailAssembly(servicesAssembler: serviceAssembly)
        
        let viewController = CollectionDetailViewController(
            collection: collection,
            viewModel: viewModel,
            nftDetailAssembly: nftDetailAssembly
        )
        
        return viewController
    }
}
