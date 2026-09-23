//
//  OrderService.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 20.09.2026.
//

import Foundation

typealias OrderCompletion = (Result<OrderResponseModel, Error>) -> Void
typealias UpdateOrderCompletion = (Result<Void, Error>) -> Void

protocol OrderService {
    func loadOrder(completion: @escaping OrderCompletion)

    func updateOrder(
        request: OrderUpdateRequestModel,
        completion: @escaping UpdateOrderCompletion
    )
}
