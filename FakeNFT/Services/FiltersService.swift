//
//  FiltersService.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 16.09.2026.
//

import Foundation

protocol FiltersServiceProtocol: AnyObject {
    func saveFilter(_ filter: Filter)
    func loadFilters() -> Filter
}

final class FiltersService: FiltersServiceProtocol {
    private let userDefaultsKey = "cart_filter"
    private let userDefaults = UserDefaults.standard
    
    func saveFilter(_ filter: Filter) {
        userDefaults.set(filter.rawValue, forKey: userDefaultsKey)
    }
    
    func loadFilters() -> Filter {
        guard let rawValue = userDefaults.string(forKey: userDefaultsKey),
              let option = Filter(rawValue: rawValue)
        else {
            return .title
        }
        return option
    }
}
