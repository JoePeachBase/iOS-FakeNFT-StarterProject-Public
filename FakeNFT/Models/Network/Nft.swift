import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let images: [URL]
<<<<<<< HEAD
=======
    let name: String
>>>>>>> 05b0345 (feat: Реализовал эпик Корзина (+1 squashed commit))
    let rating: Int
    let price: Double
}
