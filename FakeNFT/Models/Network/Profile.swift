//
//  Profile.swift
//  FakeNFT
//
//  Created by Irina Deeva on 01/05/24.
//

import Foundation

struct Profile: Codable {
    let userId: UUID
    let userName: String
    let imageURL: URL?
    let description: String
    let nftIds: [UUID]
    let userWebsite: URL
    let userRating: String

    private enum CodingKeys: String, CodingKey {
        case userId = "id"
        case userName = "name"
        case imageURL = "avatar"
        case description = "description"
        case userWebsite = "website"
        case nftIds = "nfts"
        case userRating = "rating"
    }
}
