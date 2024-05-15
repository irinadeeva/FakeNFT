//
//  UploadProfile.swift
//  FakeNFT
//
//  Created by Irina Deeva on 15/05/24.
//

import Foundation

struct UploadProfile: Encodable {
    let name: String
    let description: String
    let website: URL
    let avatar: URL
    let likes: [String]
}
