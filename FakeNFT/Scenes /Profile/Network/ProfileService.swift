//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 18.09.2026.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    
    func updateProfile(likes: [String], completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        let request = GetProfileRequest()
        
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(likes: [String], completion: @escaping ProfileCompletion) {
        let request = UpdateProfileRequest(likes: likes)
        
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
