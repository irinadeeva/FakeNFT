import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double

    let author: String
    let createdAt: String
    var description: String

        init(nft: Nft) {
            self.createdAt = nft.createdAt
            self.name = nft.name
            self.images = nft.images
            self.rating = nft.rating
            self.description = nft.description
            self.price = nft.price
            self.author = nft.author
            self.id = nft.id
        }
}
