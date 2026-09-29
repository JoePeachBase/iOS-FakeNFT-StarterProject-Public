//
//  Order.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import Foundation

// MARK: - Base Protocol
protocol OrderBaseRequestModel: NetworkRequest {
    var id: String { get }
}

extension OrderBaseRequestModel {
    var endpoint: URL? {
        guard let baseUrl = URL(string: RequestConstants.baseURL) else { return nil }
        return baseUrl
            .appendingPathComponent("api")
            .appendingPathComponent("v1")
            .appendingPathComponent("orders")
            .appendingPathComponent(id)
    }
}

// MARK: - Request Model
struct OrderRequest: OrderBaseRequestModel {
    let id: String
    let httpMethod: HttpMethod
    let dto: Dto?
    
    static func get(id: String) -> OrderRequest {
        OrderRequest(id: id, httpMethod: .get, dto: nil)
    }
    
    static func put(id: String, nfts: [String]) -> OrderRequest {
        OrderRequest(id: id, httpMethod: .put, dto: OrderPutDto(nfts: nfts))
    }
}

// MARK: - DTO
struct OrderPutDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String : String] {
        guard !nfts.isEmpty else { return [:] }
        return ["nfts": nfts.joined(separator: ",")]
    }
}

// MARK: - Response Model
struct OrderResponse: Decodable {
    let id: String
    let nfts: [String]
}
