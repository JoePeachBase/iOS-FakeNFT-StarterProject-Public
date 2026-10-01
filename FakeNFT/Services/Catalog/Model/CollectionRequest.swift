//
//  CollectionRequest.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 10.09.2026.
//

import Foundation

struct CollectionRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL )/api/v1/collections")
    }
    
    var dto: Dto? {
        nil
    }
}
