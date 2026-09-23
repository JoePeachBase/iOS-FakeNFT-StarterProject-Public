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
    var onActionError: ((Error) -> Void)?
    
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
    private let profileService: ProfileService
    private let orderService: OrderService
    private let loadSyncQueueLabel = "collectionDetail.load.sync"
    
    private(set) var state: CollectionDetailState = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    private var favoriteIDs: Set<String> = []
    private var updatingFavoriteIDs: Set<String> = []
    private var nfts: [Nft] = []
    private var cartIDs: Set<String> = []
    private var updatingCartIDs: Set<String> = []
    
    init(
        collection: NFTCollection,
        nftService: NftService,
        profileService: ProfileService,
        orderService: OrderService
    ) {
        self.collection = collection
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }
    
    func loadNfts() {
        state = .loading
        
        let group = DispatchGroup()
        let syncQueue = DispatchQueue(label: loadSyncQueueLabel)
        
        var loadedNfts: [Nft] = []
        var loadingError: Error?
        
        group.enter()
        
        nftService.loadNfts(ids: collection.nfts) { result in
            
            syncQueue.async {
                switch result {
                case .success(let nfts):
                    loadedNfts = nfts
                    
                case .failure(let error):
                    if loadingError == nil {
                        loadingError = error
                    }
                }
                group.leave()
            }
        }
        
        group.enter()
        
        loadProfile { result in
            switch result {
            case .success:
                group.leave()
                
            case .failure(let error):
                syncQueue.async {
                    if loadingError == nil {
                        loadingError = error
                    }
                    group.leave()
                }
            }
        }
        
        group.enter()
        
        loadOrder { result in
            switch result {
            case .success:
                group.leave()

            case .failure(let error):
                syncQueue.async {
                    if loadingError == nil {
                        loadingError = error
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
            
            self.nfts = loadedNfts
            
            let cellModels = self.nfts
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
    
    func makeActionErrorModel(_ error: Error) -> ErrorModel {
        let message: String

        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Common.close", comment: "")

        return ErrorModel(
            message: message,
            actionText: actionText,
            action: {}
        )
    }
    
    func toggleFavorite(nftID: String) {
        guard !updatingFavoriteIDs.contains(nftID) else { return }
        
        let wasFavorite = favoriteIDs.contains(nftID)
        
        if wasFavorite {
            favoriteIDs.remove(nftID)
        } else {
            favoriteIDs.insert(nftID)
        }
        
        updatingFavoriteIDs.insert(nftID)
        updateCellModels()
        
        profileService.updateProfile(likes: Array(favoriteIDs)) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.favoriteIDs = Set(profile.likes)
                    self.updatingFavoriteIDs.remove(nftID)
                    self.updateCellModels()
                    
                case .failure(let error):
                    if wasFavorite {
                        self.favoriteIDs.insert(nftID)
                    } else {
                        self.favoriteIDs.remove(nftID)
                    }
                    
                    self.updatingFavoriteIDs.remove(nftID)
                    self.updateCellModels()
                    self.onActionError?(error)
                }
            }
            
        }
    }
    
    func toggleCart(nftID: String) {
        guard !updatingCartIDs.contains(nftID) else { return }
        
        let wasInCart = cartIDs.contains(nftID)
        
        if wasInCart {
            cartIDs.remove(nftID)
        } else {
            cartIDs.insert(nftID)
        }
        updatingCartIDs.insert(nftID)
        updateCellModels()
        
        let request = OrderUpdateRequestModel(nfts: Array(cartIDs))
        
        orderService.updateOrder(request: request) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updatingCartIDs.remove(nftID)
                    self.updateCellModels()
                    
                case .failure(let error):
                    if wasInCart {
                        self.cartIDs.insert(nftID)
                    } else {
                        self.cartIDs.remove(nftID)
                    }
                    
                    self.updatingCartIDs.remove(nftID)
                    self.updateCellModels()
                    self.onActionError?(error)
                }
            }
        }
    }
    
    func isFavoriteUpdating(nftID: String) -> Bool {
        updatingFavoriteIDs.contains(nftID)
    }
    
    private func makeCellModel(from nft: Nft) -> CollectionNFTCellModel {
        CollectionNFTCellModel(
            id: nft.id,
            name: nft.name.capitalized,
            imageURL: nft.images.first,
            rating: nft.rating,
            price: "\(nft.price) ETH",
            isFavorite: favoriteIDs.contains(nft.id),
            isFavoriteUpdating: updatingFavoriteIDs.contains(nft.id),
            isInCart: cartIDs.contains(nft.id),
            isCartUpdating: updatingCartIDs.contains(nft.id)
        )
    }
    
    private func loadProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        profileService.loadProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.favoriteIDs = Set(profile.likes)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func updateCellModels() {
        let cellModels = nfts.map { makeCellModel(from: $0) }
        state = .loaded(cellModels)
    }
    
    private func loadOrder(completion: @escaping (Result<OrderResponseModel, Error>) -> Void) {
        orderService.loadOrder { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let order):
                self.cartIDs = Set(order.nfts)
                completion(.success(order))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
