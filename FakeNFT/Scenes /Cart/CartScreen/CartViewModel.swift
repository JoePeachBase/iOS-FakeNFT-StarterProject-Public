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
    var deleteNftState: Observable<ViewState<Void>> { get }
    var event: Observable<CartEvent?> { get }
    var nfts: [NftModel] { get }
    var totalCountText: String { get }
    var totalSumText: String{ get }
    var orderId: String { get }
    var currentSortOption: CartSortOption { get }
    
    func fetchOrder()
    func deleteNft(with id: String)
    func changeSortOption(_ sortOption: CartSortOption)
}

final class CartViewModel: CartViewModelProtocol {
    let state = Observable<ViewState<OrderModel>>(.idle)
    let deleteNftState = Observable<ViewState<Void>>(.idle)
    let event: Observable<CartEvent?> = Observable(nil)
    let orderId: String
    var currentSortOption: CartSortOption
    
    private let orderService: CartServiceProtocol
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
        orderService: CartServiceProtocol,
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
                AppDelegate.logger.error("Ошибка при загрузке заказа", metadata: ["error": "\(error)"])
                state.value = .failure(error)
            }
        }
    }
    
    func deleteNft(with id: String) {
        deleteNftState.value = .loading
        let updatedNftIds = nfts
            .filter { $0.id != id }
            .map { $0.id }
        
        orderService.updateOrder(id: orderId, nfts: updatedNftIds) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                deleteNftState.value = .success(())
                fetchOrder()
            case .failure(let error):
                AppDelegate.logger.error("Ошибка при удалении NFT", metadata: ["error": "\(error)"])
                deleteNftState.value = .failure(error)
            }
        }
    }
    
    func changeSortOption(_ sortOption: CartSortOption) {
        sortService.saveSortOption(sortOption)
        currentSortOption = sortOption
        
        event.value = .orderSorted
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
