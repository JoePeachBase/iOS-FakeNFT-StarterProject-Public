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
    
    func build() -> UIViewController {
        let viewModel = PaymentViewModel(servicesAssembler.currencyService)
        return PaymentViewController(viewModel)
    }
}
