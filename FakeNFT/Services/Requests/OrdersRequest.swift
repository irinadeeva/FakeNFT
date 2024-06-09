import Foundation

struct GetOrdersRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }

    var dto: Data?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct PutOrdersRequest: NetworkRequest {
    var httpMethod: HttpMethod { .put }

    var dto: Data? {
        return params.data(using: .utf8)
    }

    var nfts: [String]

    var params: String {
        var params = ""
        nfts.forEach {
            params += "nfts=" + $0 + "&"
        }
        return params
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
