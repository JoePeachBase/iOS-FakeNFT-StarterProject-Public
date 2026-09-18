//
//  UpdateProfileRequest.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 18.09.2026.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var likes: [String]
    var httpMethod: HttpMethod = .put
    var dto: Dto? {
        LikesDtoObject(likes: likes)
    }
}

struct LikesDtoObject: Dto {
    let likes: [String]
    
    var joinedLikes: String {
        likes.isEmpty ?
        "null"
        : likes.joined(separator: ",")
    }
    
    enum CodingKeys: String, CodingKey {
        case likes = "likes"
    }
    
    func asDictionary() -> [String : String] {
        [CodingKeys.likes.rawValue: joinedLikes]
    }
}
