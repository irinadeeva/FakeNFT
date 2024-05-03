//
//  Profile.swift
//  FakeNFT
//
//  Created by Irina Deeva on 01/05/24.
//

import Foundation

struct Profile: Codable {
    // TODO: find out what is optional
//    let userId: UUID
    let userName: String
//    let profileImage: URL?
    let description: String?
//    let nftIds: [UUID]?
//    let userWebsite: URL?
//    let userRating: Int?

    private enum CodingKeys: String, CodingKey {
//        case userId = "id"
        case userName = "name"
//        case profileImage = "avatar"
        case description = "description"
//        case userWebsite = "website"
//        case nftIds = "nfts"
//        case userRating = "rating"
    }
}
