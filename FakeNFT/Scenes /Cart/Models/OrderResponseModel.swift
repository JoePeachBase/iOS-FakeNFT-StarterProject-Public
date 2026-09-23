//
//  OrderResponseModel.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 20.09.2026.
//

import Foundation

struct OrderResponseModel: Decodable {
    let nfts: [String]
    let id: String
}
