//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }

    var dto: Data?

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
