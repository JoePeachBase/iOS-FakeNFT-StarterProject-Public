//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

final class CartViewModel {
    let state = Observable<ViewState<[NftUiModel]>>(.loading)
    
    func fetchOrder() {
        // TODO Добавить запрос
    }
}
