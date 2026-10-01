//
//  NftUiModel.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

import Foundation

struct NftModel {
    let id: String
    let title: String
    let imageURL: URL?
    let rating: Int
    let formattedPrice: String
    let price: Double
}

extension NftModel {
    init(model: Nft) {
        id = model.id
        title = model.name
        imageURL = model.images.first
        rating = model.rating
        formattedPrice = "\(model.price) ETH"
        price = model.price
    }
}
