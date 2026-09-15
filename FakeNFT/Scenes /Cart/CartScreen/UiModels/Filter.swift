//
//  SortOption.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 16.09.2026.
//

import Foundation

enum Filter: String, CaseIterable {
    case price
    case rating
    case title
    
    var title: String {
        switch self {
        case .price:
            return NSLocalizedString("Cart.filters.byPrice", comment: "")
        case .rating:
            return NSLocalizedString("Cart.filters.byRating", comment: "")
        case .title:
            return NSLocalizedString("Cart.filters.byTitle", comment: "")
        }
    }
}
