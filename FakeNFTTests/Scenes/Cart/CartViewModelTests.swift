//
//  CartViewModelTests.swift
//  FakeNFT
//
//  Created by Мамытов Руслан on 01.10.2026.
//

@testable import FakeNFT
import XCTest

final class CartViewModelTests: XCTestCase {
    func testChangeSortOptionByPrice() {
        // Given
        let expected = [2.0, 3.0, 15.0]
        let viewModel = makeViewModelWithLoadedNfts(
            nfts:[
                makeNft(title: "NFT 1", rating: 1, price: 15.0),
                makeNft(title: "NFT 2", rating: 4, price: 3.0),
                makeNft(title: "NFT 3", rating: 3, price: 2.0),
            ]
        )
        
        // When
        viewModel.changeSortOption(.price)
        let actual = viewModel.nfts.map(\.price)
        
        // Then
        XCTAssertEqual(expected, actual)
    }
    
    func testChangeSortOptionByTitle() {
        // Given
        let expected = ["NFT 4", "NFT 2", "NFT 6"]
        let viewModel = makeViewModelWithLoadedNfts(
            nfts:[
                makeNft(title: "NFT 6", rating: 1, price: 15.0),
                makeNft(title: "NFT 2", rating: 4, price: 3.0),
                makeNft(title: "NFT 4", rating: 3, price: 2.0),
            ]
        )
        
        // When
        viewModel.changeSortOption(.price)
        let actual = viewModel.nfts.map(\.title)
        
        // Then
        XCTAssertEqual(expected, actual)
    }
    
    func testChangeSortOptionByRating() {
        // Given
        let expected = [4, 3, 1]
        let viewModel = makeViewModelWithLoadedNfts(
            nfts:[
                makeNft(title: "NFT 1", rating: 1, price: 15.0),
                makeNft(title: "NFT 2", rating: 4, price: 3.0),
                makeNft(title: "NFT 3", rating: 3, price: 2.0),
            ]
        )
        
        // When
        viewModel.changeSortOption(.rating)
        let actual = viewModel.nfts.map(\.rating)
        
        // Then
        XCTAssertEqual(expected, actual)
    }
    
    private func makeViewModelWithLoadedNfts(nfts: [NftModel]) -> CartViewModelProtocol {
        let cartService = CartServiceMock(nfts: nfts)
        let sortService = CartSortOptionServiceMock()
        let cartViewModel = CartViewModel(
            orderId: "1",
            cartService: cartService,
            sortService: sortService
        )
        
        cartViewModel.fetchOrder()
        
        return cartViewModel
    }
    
    private func makeNft(
        title: String,
        rating: Int,
        price: Double
    ) -> NftModel {
        NftModel(
            id: "",
            title: title,
            imageURL: nil,
            rating: rating,
            formattedPrice: "",
            price: price
        )
    }
}
