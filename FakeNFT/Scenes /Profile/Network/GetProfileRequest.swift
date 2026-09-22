//
//  GetProfileRequest.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 18.09.2026.
//

import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL (string: "\(RequestConstants.baseURL)\(RequestConstants.profilePath)")
    }
    
    var dto: Dto? {
        nil
    }
}
