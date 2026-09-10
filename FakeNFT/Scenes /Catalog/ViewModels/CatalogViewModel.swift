//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 10.09.2026.
//

import Foundation

enum CatalogState {
    case initial
    case loading
    case loaded([NFTCollection])
    case failed(Error)
}

final class CatalogViewModel {
    
    var onStateChanged: ((CatalogState) -> Void)?
    var numberOfCollections: Int {
        switch state {
        case .loaded(let collections):
            collections.count
        default: 0
        }
    }
    
    private let collectionService: CollectionService
    
    private(set) var state: CatalogState = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    init(collectionService: CollectionService) {
        self.collectionService = collectionService
    }
    
    func loadCollections() {
        state = .loading
        
        collectionService.loadCollections { [weak self] result in
            switch result {
            case .success(let collections):
                self?.state = .loaded(collections)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    func cellModel(at index: Int) -> CatalogCellModel? {
        switch state {
        case .loaded(let collections):
            guard index >= 0 && index < collections.count else {
                return nil
            }
            let collection = collections[index]
            
            return CatalogCellModel(
                title: "\(collection.name) (\(collection.nftCount))",
                coverURL: URL(string: collection.cover)
            )
        default:
            return nil
        }
    }
    
    func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) {
            [weak self] in
            self?.loadCollections()
        }
    }
    
    func sort(by option: CatalogSortOption) {
        guard case .loaded(let collections) = state else { return }
        
        switch option {
        case .name:
            let sortedCollections = collections.sorted { $0.name < $1.name }
            state = .loaded(sortedCollections)
        case .nftCount:
            let sortedCollections = collections.sorted { $0.nftCount > $1.nftCount }
            state = .loaded(sortedCollections)
        }
    }
}
