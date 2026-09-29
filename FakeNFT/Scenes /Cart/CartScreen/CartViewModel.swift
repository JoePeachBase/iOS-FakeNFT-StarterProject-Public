//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 15.09.2026.
//

enum CartEvent {
    case dataLoaded
    case nftDeleted(id: String)
    case orderSorted
}

protocol CartViewModelProtocol {
    var state: Observable<ViewState<OrderModel>> { get }
    var event: Observable<CartEvent?> { get }
    var nfts: [NftModel] { get }
    var totalCountText: String { get }
    var totalSumText: String{ get }
    var currentSortOption: CartSortOption { get }
    
    func fetchOrder()
    func deleteNft(with id: String)
    func changeSortOption(_ sortOption: CartSortOption)
}

final class CartViewModel: CartViewModelProtocol {
    let state = Observable<ViewState<OrderModel>>(.idle)
    let event: Observable<CartEvent?> = Observable(nil)
    var currentSortOption: CartSortOption
    
    private let orderId: String
    private let orderService: CartOrderServiceProtocol
    private let sortService: CartSortOptionServiceProtocol
    
    var nfts: [NftModel] {
        guard case .success(let model) = state.value else { return [] }
        return sort(model.nfts, with: currentSortOption)
    }
    
    var totalCountText: String {
        return "\(nfts.count) NFT"
    }
    
    var totalSumText: String {
        let totalSum = nfts.reduce(0) { $0 + $1.price }
        return "\(totalSum) ETH"
    }
    
    init(
        orderId: String,
        orderService: CartOrderServiceProtocol,
        sortService: CartSortOptionServiceProtocol
    ) {
        self.orderId = orderId
        self.orderService = orderService
        self.sortService = sortService
        self.currentSortOption = sortService.loadSortOption()
    }
    
    func fetchOrder() {
        state.value = .loading
        orderService.fetchOrder(id: orderId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let order):
                state.value = .success(order)
                event.value = .dataLoaded
            case .failure(let error):
                state.value = .failure(error)
            }
        }
    }
    
    func changeSortOption(_ sortOption: CartSortOption) {
        sortService.saveSortOption(sortOption)
        currentSortOption = sortOption
        
        event.value = .orderSorted
    }
    
    func deleteNft(with id: String) {
        guard case .success(let currentModel) = state.value else {
            return
        }
        
        let updatedNfts = currentModel.nfts.filter { $0.id != id }
        let updatedModel = OrderModel(id: currentModel.id, nfts: updatedNfts)
        
        state.value = .success(updatedModel)
        event.value = .nftDeleted(id: id)
    }
    
    private func sort(_ nfts: [NftModel], with sortOption: CartSortOption) -> [NftModel] {
        switch sortOption {
        case .title:
            return nfts
                .sorted {
                    $0.title.localizedCompare($1.title) == .orderedAscending
                }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .price:
            return nfts.sorted { $0.price < $1.price }
        }
    }
}
