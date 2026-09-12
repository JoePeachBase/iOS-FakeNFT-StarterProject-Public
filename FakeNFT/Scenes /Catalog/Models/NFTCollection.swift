//
//  NFTCollection.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 10.09.2026.
//

import Foundation

struct NFTCollection: Decodable {
    let name: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
    let cover: String
    let website: String
    
    var nftCount: Int {
        nfts.count
    }
}
