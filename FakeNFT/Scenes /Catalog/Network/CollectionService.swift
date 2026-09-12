//
//  CollectionService.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 10.09.2026.
//

import Foundation

typealias CollectionCompletion = (Result<[NFTCollection], Error>) -> Void

protocol CollectionService {
    func loadCollections(completion: @escaping CollectionCompletion)
}

final class CollectionServiceImpl: CollectionService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections(completion: @escaping CollectionCompletion) {
        let request = CollectionRequest()
        
        networkClient.send(request: request, type: [NFTCollection].self) { result in
            switch result {
            case .success(let collections): completion(.success(collections))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
