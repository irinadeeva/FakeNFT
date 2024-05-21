//
//  Profile.swift
//  FakeNFT
//
//  Created by Irina Deeva on 01/05/24.
//

import Foundation

struct Profile: Decodable {
    let id: UUID
    let name: String
    let avatar: String?
    let description: String
    let nfts: [String]
    let website: String
    let likes: [String]
}
