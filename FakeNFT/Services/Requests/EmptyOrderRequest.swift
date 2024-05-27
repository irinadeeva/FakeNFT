//
//  EmptyOrderRequest.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 20.05.2024.
//

import Foundation

struct EmptyOrderRequest: NetworkRequest {

    var httpMethod: HttpMethod { .put }
    var nfts: [String]?

    var endpoint: URL? {
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/orders/1")

        var components: [URLQueryItem] = []

        urlComponents?.queryItems = components
        return urlComponents?.url
    }

    var isUrlEncoded: Bool {
      return true
    }

    var dto: Encodable?

    init(nfts: [String]) {
        self.nfts = nfts
    }
}
