//
//  CartSortOptionServiceMock.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 01.10.2026.
//

@testable import FakeNFT

final class CartSortOptionServiceMock: CartSortOptionServiceProtocol {
    func saveSortOption(_ option: CartSortOption) {}
    func loadSortOption() -> CartSortOption {
        .price
    }
}
