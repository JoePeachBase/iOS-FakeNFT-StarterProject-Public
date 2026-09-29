//
//  Order.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
    var dto: Dto?
}

struct OrderResponse: Decodable {
    let id: String
    let nfts: [String]
}
