import Foundation

struct Nft: Decodable {
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
    let id: String
    
}
