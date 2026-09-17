//
//  CollectionDetailViewModel.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 13.09.2026.
//

import Foundation

enum CollectionDetailState {
    case initial
    case loading
    case loaded([CollectionNFTCellModel])
    case failed(Error)
}

final class CollectionDetailViewModel {
    
    var onStateChanged: ((CollectionDetailState) -> Void)?
    
    var headerModel: CollectionDetailHeaderModel {
        CollectionDetailHeaderModel(
            name: collection.name.capitalized,
            description: collection.description,
            author: collection.author,
            coverURL: URL(string: collection.cover)
        )
    }
    
    var nftCount: Int {
        collection.nfts.count
    }
    
    private let collection: NFTCollection
    private let nftService: NftService
    private let syncQueue = DispatchQueue(label: "collectionDetail.syncQueue")
    
    private(set) var state: CollectionDetailState = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    init(collection: NFTCollection, nftService: NftService) {
        self.collection = collection
        self.nftService = nftService
    }
    
    func loadNfts() {
        state = .loading
        
        let group = DispatchGroup()
        var loadedNfts = Array<Nft?>(repeating: nil, count: collection.nfts.count)
        var loadingError: Error?
        
        for (index, nftID) in collection.nfts.enumerated() {
            group.enter()
            
            nftService.loadNft(id: nftID) { [weak self] result in
                guard let self else {
                    group.leave()
                    return
                }
                
                self.syncQueue.async {
                    switch result {
                    case .success(let nft): loadedNfts[index] = nft
                        
                    case .failure(let error):
                        if loadingError == nil {
                            loadingError = error
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            if let loadingError {
                self.state = .failed(loadingError)
                return
            }
            let cellModels = loadedNfts
                .compactMap { $0 }
                .map { self.makeCellModel(from: $0) }
            
            self.state = .loaded(cellModels)
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
        
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.loadNfts()
        }
    }
    
    private func makeCellModel(from nft: Nft) -> CollectionNFTCellModel {
        CollectionNFTCellModel(
            id: nft.id,
            name: nft.name.capitalized,
            imageURL: nft.images.first,
            rating: nft.rating,
            price: "\(nft.price) ETH"
        )
    }
}
