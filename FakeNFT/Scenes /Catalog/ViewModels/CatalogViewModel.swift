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
        case .loading:
            return 4
        case .loaded(let collections):
            return collections.count
        default:
            return 0
        }
    }
    
    private let collectionService: CollectionService
    private let sortOptionKey = "catalogSortOption"
    
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
            guard let self else { return }
            switch result {
            case .success(let collections):
                if let sortOption = self.loadSortOption() {
                    let sortedCollections = self.sortedCollections(collections, by: sortOption)
                    self.state = .loaded(sortedCollections)
                } else {
                    self.state = .loaded(collections)
                }
                
            case .failure(let error):
                self.state = .failed(error)
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
                title: "\(collection.name.capitalized) (\(collection.nftCount))",
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

        let sortedCollections = sortedCollections(collections, by: option)
        saveSortOption(option)
        state = .loaded(sortedCollections)
    }
    
    func collection(at index: Int) -> NFTCollection? {
        switch state {
        case .loaded(let collections):
            guard index >= 0 && index < collections.count else { return nil }
            return collections[index]
        default: return nil
        }
    }
    
    private func saveSortOption(_ option: CatalogSortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }
    
    private func loadSortOption() -> CatalogSortOption? {
        guard let rawValue = UserDefaults.standard.string(forKey: sortOptionKey) else { return nil }
        return CatalogSortOption.init(rawValue: rawValue)
    }
    
    private func sortedCollections(_ collections: [NFTCollection], by option: CatalogSortOption) -> [NFTCollection] {
        switch option {
        case .name:
            collections.sorted { $0.name < $1.name }
        case .nftCount:
            collections.sorted { $0.nftCount > $1.nftCount }
        }
    }
}
