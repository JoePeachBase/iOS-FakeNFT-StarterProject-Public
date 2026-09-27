//
//  CartOrderService.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import Foundation

typealias OrderCompletion = (Result<OrderResponse, Error>) -> Void

protocol CartOrderServiceProtocol {
    func fetchOrder(id: String, completion: @escaping OrderCompletion)
}

final class CartOrderService: CartOrderServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchOrder(id: String, completion: @escaping OrderCompletion) {
        let request = OrderRequest(id: id)
        
        networkClient.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
