//
//  UpdateProfileRequest.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 18.09.2026.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(RequestConstants.profilePath)")
    }
    
    var dto: Dto? {
        LikesDtoObject(likes: likes)
    }
    
    let likes: [String]
    let httpMethod: HttpMethod = .put
}

struct LikesDtoObject: Dto {
    let likes: [String]
    
    var joinedLikes: String {
        likes.isEmpty ?
        "null"
        : likes.joined(separator: ",")
    }
    
    func asDictionary() -> [String : String] {
        ["likes": joinedLikes]
    }
}
