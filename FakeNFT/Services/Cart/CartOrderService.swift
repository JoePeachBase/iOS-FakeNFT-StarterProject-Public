//
//  CartOrderService.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 27.09.2026.
//

import Foundation

typealias OrderCompletion = (Result<OrderModel, Error>) -> Void

protocol CartOrderServiceProtocol {
    func fetchOrder(id: String, completion: @escaping OrderCompletion)
}

final class CartOrderService: CartOrderServiceProtocol {
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
        let request = OrderRequest(id: id)
        
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
                guard let self = self else { return }
                
                defer { group.leave() }
                
                switch result {
                case .success(let nft):
                    self.serialQueue.async {
                        loadedNfts.append(nft)
                    }
                case .failure(let error):
                    self.serialQueue.async {
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
