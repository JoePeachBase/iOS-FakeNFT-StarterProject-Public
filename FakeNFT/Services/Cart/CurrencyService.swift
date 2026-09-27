//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 28.09.2026.
//

import Foundation

typealias CurrencyCompletion = (Result<[CurrencyModel], Error>) -> Void

protocol CurrencyServiceProtocol {
    func fetchCurrencies(completion: @escaping CurrencyCompletion)
}

final class CurrencyService: CurrencyServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCurrencies(completion: @escaping CurrencyCompletion) {
        let request = CurrencyRequest()
        networkClient.send(request: request, type: [CurrencyResponse].self) { result in
            switch result {
            case .success(let response):
                print("success")
                completion(.success(response.map({ .init(model: $0) })))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
