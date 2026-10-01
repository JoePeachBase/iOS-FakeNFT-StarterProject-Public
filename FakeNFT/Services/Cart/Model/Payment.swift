//
//  Payment.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 30.09.2026.
//

import Foundation

struct PaymentRequest: NetworkRequest {
    let id: String
    let currencyId: String
    let httpMethod: HttpMethod = .get
    var endpoint: URL? {
        guard let baseUrl = URL(string: RequestConstants.baseURL) else { return nil }
        return baseUrl.appending(path: "api/v1/orders/\(id)/payment/\(currencyId)", directoryHint: .notDirectory)
    }
}

struct PaymentResponse: Decodable {
    let id: String
    let orderId: String
    let success: Bool
}
