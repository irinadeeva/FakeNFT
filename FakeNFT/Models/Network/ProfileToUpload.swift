//
//  UploadProfile.swift
//  FakeNFT
//
//  Created by Irina Deeva on 15/05/24.
//

import Foundation

struct ProfileToUpload: Encodable {
    let userName: String
    let description: String
    let userWebsite: URL
    let imageURL: URL?
    var likes: [String]

    private enum CodingKeys: String, CodingKey {
        case userName = "name"
        case imageURL = "avatar"
        case description = "description"
        case userWebsite = "website"
        case likes = "likes"
    }
}
