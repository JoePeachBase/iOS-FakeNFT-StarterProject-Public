//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 26.09.2026.
//

protocol PaymentViewModelProtocol {
    var state: Observable<ViewState<[CurrencyModel]>> { get }
    var currencies: [CurrencyModel] { get }
    var selectedCurrencyId: String? { get }
    
    func fetchCurrencies()
    func onCurrencyTap(with id: String)
    func makePayment()
}

final class PaymentViewModel: PaymentViewModelProtocol {
    let state = Observable<ViewState<[CurrencyModel]>>(.idle)
    var selectedCurrencyId: String?
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
    
    func onCurrencyTap(with id: String) {
        if id == selectedCurrencyId {
            selectedCurrencyId = nil
        } else {
            selectedCurrencyId = id
        }
    }
    
    func makePayment() {
        
    }
}
