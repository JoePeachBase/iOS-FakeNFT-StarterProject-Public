//
//  MockOrderService.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 20.09.2026.
//

import Foundation

final class MockOrderService: OrderService {
    private var nftIDs: [String] = []

    func loadOrder(completion: @escaping OrderCompletion) {
        let order = OrderResponseModel(
            nfts: nftIDs,
            id: "1"
        )

        completion(.success(order))
    }

    func updateOrder(
        request: OrderUpdateRequestModel,
        completion: @escaping UpdateOrderCompletion
    ) {
        nftIDs = request.nfts
        completion(.success(()))
    }
}
