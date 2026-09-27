//
//  CurrencyUiModel.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//
import Foundation

struct CurrencyModel {
    let id: String
    let imageURL: String
    let title: String
    let subtitle: String
    
    init(model: CurrencyResponse) {
        id = model.id
        imageURL = model.image
        title = model.title
        subtitle = model.name
    }
}
