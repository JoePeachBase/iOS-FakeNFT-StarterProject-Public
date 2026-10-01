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
    var currencies: [CurrencyModel] {
        guard case .success(let currencies) = state.value else { return [] }
        return currencies
    }
    
    private let orderId: String
    private let cartService: CartServiceProtocol
    private let currencyService: CurrencyServiceProtocol
    private var isPaymentCompleted = false
    
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
                AppDelegate.logger.error("Ошибка при запросе валют", metadata: ["error": "\(error)"])
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
        
        if isPaymentCompleted {
            completeOrder()
            return
        }
        
        paymentState.value = .loading
        
        cartService.makePayment(id: orderId, currencyId: selectedCurrencyId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                isPaymentCompleted = true
                completeOrder()
            case .failure(let error):
                onMakePaymentError(error)
            }
        }
    }
    
    private func completeOrder() {
        let nfts: [String] = []
        cartService.updateOrder(id: orderId, nfts: nfts) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                paymentState.value = .success(())
            case .failure(let error):
                onMakePaymentError(error)
            }
        }
    }
    
    private func onMakePaymentError(_ error: Error) {
        AppDelegate.logger.error("Ошибка при оплате заказа", metadata: ["error": "\(error)"])
        paymentState.value = .failure(error)
    }
}
