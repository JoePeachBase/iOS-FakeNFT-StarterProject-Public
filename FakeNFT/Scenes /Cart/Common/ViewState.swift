//
//  ViewState.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

enum ViewState<T> {
    case loading
    case success(T)
    case failure(Error)
    case empty
}
