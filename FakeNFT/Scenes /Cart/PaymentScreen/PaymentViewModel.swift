//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 26.09.2026.
//

protocol PaymentViewModelProtocol {
    var state: Observable<ViewState<[CurrencyModel]>> { get }
    var currencies: [CurrencyModel] { get }
    
    func fetchCurrencies()
}

final class PaymentViewModel: PaymentViewModelProtocol {
    let state = Observable<ViewState<[CurrencyModel]>>(.idle)
    private let service: CurrencyServiceProtocol
    
    var currencies: [CurrencyModel] {
        guard case .success(let currencies) = state.value else { return [] }
        return currencies
    }
    
    init(_ service: CurrencyServiceProtocol) {
        self.service = service
    }
    
    func fetchCurrencies() {
        state.value = .loading
        service.fetchCurrencies { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let model):
                state.value = .success(model)
            case .failure(let error):
                state.value = .failure(error)
            }
        }
    }
}
