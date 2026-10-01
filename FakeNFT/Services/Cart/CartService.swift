//
//  CartOrderService.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import Foundation

enum CartServiceError: Error {
    case paymentError
}

extension CartServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .paymentError:
            NSLocalizedString("Payment.error.message", comment: "")
        }
    }
}

typealias OrderCompletion = (Result<OrderModel, Error>) -> Void
typealias UpdateOrderCompletion = (Result<Void, Error>) -> Void
typealias PaymentCompletion = (Result<Void, Error>) -> Void

protocol CartServiceProtocol {
    func fetchOrder(id: String, completion: @escaping OrderCompletion)
    func updateOrder(id: String, nfts: [String], completion: @escaping UpdateOrderCompletion)
    func makePayment(id: String, currencyId: String, completion: @escaping PaymentCompletion)
}

final class CartService: CartServiceProtocol {
    private let networkClient: NetworkClient
    private let nftService: NftService
    private let serialQueue = DispatchQueue(label: "com.app.cartServiceSerialQueue")
    
    init(
        networkClient: NetworkClient,
        nftService: NftService
    ) {
        self.networkClient = networkClient
        self.nftService = nftService
    }
    
    func fetchOrder(id: String, completion: @escaping OrderCompletion) {
        let request = OrderRequest.get(id: id)
        
        networkClient.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let order):
                self.fetchNfts(by: order.nfts) { result in
                    switch result {
                    case .success(let nfts):
                        completion(.success(OrderModel(id: order.id, nfts: nfts.map({.init(model: $0)}))))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(id: String, nfts: [String], completion: @escaping UpdateOrderCompletion) {
        let request = OrderRequest.put(id: id, nfts: nfts)
        
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func makePayment(id: String, currencyId: String, completion: @escaping PaymentCompletion) {
        let request = PaymentRequest(id: id, currencyId: currencyId)
        
        networkClient.send(request: request, type: PaymentResponse.self) { result in
            switch result {
            case .success(let response):
                response.success
                ? completion(.success(()))
                : completion(.failure(CartServiceError.paymentError))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchNfts(by ids: [String], completion: @escaping (Result<[Nft], Error>) -> Void) {
        guard !ids.isEmpty else {
            completion(.success([]))
            return
        }
        
        let group = DispatchGroup()
        var loadedNfts: [Nft] = []
        var firstError: Error?
        
        for id in ids {
            group.enter()
            
            nftService.loadNft(id: id) { [weak self] result in
                defer { group.leave() }
                
                guard let self else { return }
                
                switch result {
                case .success(let nft):
                    serialQueue.async {
                        loadedNfts.append(nft)
                    }
                case .failure(let error):
                    serialQueue.async {
                        if firstError == nil { firstError = error }
                    }
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            self.serialQueue.sync {
                if let error = firstError {
                    completion(.failure(error))
                } else {
                    completion(.success(loadedNfts))
                }
            }
        }
    }
}
