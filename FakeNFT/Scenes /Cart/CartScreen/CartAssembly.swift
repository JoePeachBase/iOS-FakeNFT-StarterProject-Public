//
//  CartAssembly.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import UIKit

final class CartAssembly {
    private let servicesAssembler: ServicesAssembly
    private let paymentAssembly: PaymentAssembly
    
    init(
        servicesAssembler: ServicesAssembly,
        paymentAssembly: PaymentAssembly
    ) {
        self.servicesAssembler = servicesAssembler
        self.paymentAssembly = paymentAssembly
    }
    
    func build() -> UIViewController {
        let viewModel = CartViewModel(
            orderId: "1",
            orderService: servicesAssembler.orderService,
            sortService: servicesAssembler.cartSortService
        )
        return CartViewController(viewModel: viewModel, paymentAssembly: paymentAssembly)
    }
}
