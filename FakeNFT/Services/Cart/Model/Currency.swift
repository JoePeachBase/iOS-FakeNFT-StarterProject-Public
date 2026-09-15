//
//  Currency.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 28.09.2026.
//

import Foundation

struct CurrencyRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    var dto: Dto?
}

struct CurrencyResponse: Decodable {
    let id: String
    let title: String
    let name: String
    let image: String
}
