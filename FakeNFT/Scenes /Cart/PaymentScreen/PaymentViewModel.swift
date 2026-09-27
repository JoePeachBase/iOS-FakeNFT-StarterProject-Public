//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 26.09.2026.
//

final class PaymentViewModel {
    let state = Observable<ViewState<[CurrencyModel]>>(.loading)
    
    func fetchCurrencies() {
        // TODO Добавить запрос
    }
}
