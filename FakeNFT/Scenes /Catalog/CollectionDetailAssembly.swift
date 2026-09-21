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
        let orderService = MockOrderService()
        let viewModel = CollectionDetailViewModel(
            collection: collection,
            nftService: serviceAssembly.nftService,
            profileService: serviceAssembly.profileService,
            orderService: orderService
        )
        
        let nftDetailAssembly = NftDetailAssembly(servicesAssembler: serviceAssembly)
        
        let viewController = CollectionDetailViewController(
            viewModel: viewModel,
            nftDetailAssembly: nftDetailAssembly
        )
        
        return viewController
    }
}
