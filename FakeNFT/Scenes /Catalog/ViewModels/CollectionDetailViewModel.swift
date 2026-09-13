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
    case loaded([Nft])
    case failed(Error)
}

final class CollectionDetailViewModel {
    
    var onStateChanged: ((CollectionDetailState) -> Void)?
    
    private let collection: NFTCollection
    private let nftService: NftService
    private let syncQueue = DispatchQueue(label: "collectionDetail.syncQueue")
    
    private(set) var state: CollectionDetailState = .initial {
        didSet{
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
            } else {
                self.state = .loaded(loadedNfts.compactMap { $0 })
            }
        }
    }
}
