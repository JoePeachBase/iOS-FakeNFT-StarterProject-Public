//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 26.09.2026.
//

protocol PaymentViewModelProtocol {
    var state: Observable<ViewState<[CurrencyModel]>> { get }
    var paymentState: Observable<ViewState<Void>> { get }
    var currencies: [CurrencyModel] { get }
    var selectedCurrencyId: String? { get }
    
    func fetchCurrencies()
    func onCurrencyTap(with id: String)
    func makePayment()
}

final class PaymentViewModel: PaymentViewModelProtocol {
    let state = Observable<ViewState<[CurrencyModel]>>(.idle)
    let paymentState = Observable<ViewState<Void>>(.idle)
    var selectedCurrencyId: String?
    private let orderId: String
    private let cartService: CartServiceProtocol
    private let currencyService: CurrencyServiceProtocol
    
    var currencies: [CurrencyModel] {
        guard case .success(let currencies) = state.value else { return [] }
        return currencies
    }
    
    init(
        orderId: String,
        cartService: CartServiceProtocol,
        currencyService: CurrencyServiceProtocol
    ) {
        self.orderId = orderId
        self.cartService = cartService
        self.currencyService = currencyService
    }
    
    func fetchCurrencies() {
        state.value = .loading
        currencyService.fetchCurrencies { [weak self] result in
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
        guard let selectedCurrencyId else { return }
        
        paymentState.value = .loading
        cartService.makePayment(id: orderId, currencyId: selectedCurrencyId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                updateOrder()
            case .failure(let error):
                paymentState.value = .failure(error)
            }
        }
    }
    
    private func updateOrder() {
        cartService.updateOrder(id: orderId, nfts: []) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                paymentState.value = .success(())
            case .failure(let error):
                paymentState.value = .failure(error)
            }
        }
    }

}
