//
//  PaymentAssembly.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 28.09.2026.
//

import UIKit

final class PaymentAssembly {
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    func build(orderId: String) -> UIViewController {
        let viewModel = PaymentViewModel(
            orderId: orderId,
            cartService: servicesAssembler.orderService,
            currencyService: servicesAssembler.currencyService
        )
        return PaymentViewController(viewModel)
    }
}
