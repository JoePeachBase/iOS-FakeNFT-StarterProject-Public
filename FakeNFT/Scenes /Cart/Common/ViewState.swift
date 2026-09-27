//
//  ViewState.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case failure(Error)
    case empty
}

extension ViewState {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    var isFailure: Bool {
        if case .failure = self { return true }
        return false
    }
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

extension ViewState where T: Collection {
    var isEmpty: Bool {
        if case .success(let collection) = self {
            return collection.isEmpty
        }
        return false
    }
}

extension ViewState where T == OrderModel {
    var isEmpty: Bool {
        if case .success(let model) = self {
            return model.nfts.isEmpty
        }
        return false
    }
}
