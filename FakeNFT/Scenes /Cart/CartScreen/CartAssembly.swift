//
//  CartAssembly.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import UIKit

final class CartAssembly {
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    func build() -> UIViewController {
        let viewModel = CartViewModel(
            orderService: servicesAssembler.orderService,
            sortService: servicesAssembler.cartSortService
        )
        return CartViewController(viewModel)
    }
}
