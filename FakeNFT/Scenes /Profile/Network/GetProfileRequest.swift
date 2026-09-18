//
//  GetProfileRequest.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 18.09.2026.
//

import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL (string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var dto: Dto? {
        nil
    }
}
