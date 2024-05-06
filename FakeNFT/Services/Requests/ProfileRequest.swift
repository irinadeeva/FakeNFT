//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Irina Deeva on 03/05/24.
//

import Foundation

struct ProfileRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}
