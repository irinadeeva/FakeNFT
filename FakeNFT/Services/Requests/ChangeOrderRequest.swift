//
//  ChangeOrderRequest.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 20.05.2024.
//

import Foundation

struct ChangeOrderRequest: NetworkRequest {
    var dto: Data?

    var httpMethod: HttpMethod { .put }
    var nfts: [String]?

    var endpoint: URL? {
        var urlComponents = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        var components: [URLQueryItem] = []

        if let nfts = self.nfts {
          for nft in nfts {
            components.append(URLQueryItem(name: "nfts", value: nft))
          }
        } else {
            components.append(URLQueryItem(name: "nfts", value: " "))
        }

        urlComponents?.queryItems = components
        return urlComponents?.url
    }

    var isUrlEncoded: Bool {
      return true
    }

    init(nfts: [String]) {
        self.nfts = nfts
    }
}
