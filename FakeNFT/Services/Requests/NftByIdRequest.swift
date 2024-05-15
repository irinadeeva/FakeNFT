import Foundation

struct NFTRequest: NetworkRequest {
    var httpMethod: HttpMethod

    var dto: (any Encodable)?

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
