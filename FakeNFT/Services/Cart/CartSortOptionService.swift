//
//  FiltersService.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 16.09.2026.
//

import Foundation

protocol CartSortOptionServiceProtocol: AnyObject {
    func saveSortOption(_ filter: CartSortOption)
    func loadSortOption() -> CartSortOption
}

final class CartSortOptionService: CartSortOptionServiceProtocol {
    private let userDefaultsKey = "cart_filter"
    private let userDefaults = UserDefaults.standard
    
    func saveSortOption(_ option: CartSortOption) {
        userDefaults.set(option.rawValue, forKey: userDefaultsKey)
    }
    
    func loadSortOption() -> CartSortOption {
        guard let rawValue = userDefaults.string(forKey: userDefaultsKey),
              let option = CartSortOption(rawValue: rawValue)
        else {
            return .title
        }
        return option
    }
}
