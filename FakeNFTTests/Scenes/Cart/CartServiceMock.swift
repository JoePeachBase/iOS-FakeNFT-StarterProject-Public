//
//  CartServiceMock.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 01.10.2026.
//

@testable import FakeNFT

final class CartServiceMock: CartServiceProtocol {
    private let nfts: [NftModel]
    
    init(nfts: [NftModel]) {
        self.nfts = nfts
    }
    
    func fetchOrder(id: String, completion: @escaping OrderCompletion) {
        let order = OrderModel(id: "", nfts: nfts)
        completion(.success(order))
    }
    
    func updateOrder(id: String, nfts: [String], completion: @escaping UpdateOrderCompletion) {}
    
    func makePayment(id: String, currencyId: String, completion: @escaping PaymentCompletion) {}
}
