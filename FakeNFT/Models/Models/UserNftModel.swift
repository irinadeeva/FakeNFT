//
//  UserNftModel.swift
//  FakeNFT
//
//  Created by artem on 15.05.2024.
//

import Foundation

struct UserNftCellModel {
    let id: String
    let name: String
    let image: URL?
    let price: String
    let rating: Int
    var like: Bool
    var order: Bool

    mutating func changeLike() {
        like.toggle()
    }

    mutating func changeOrder() {
        order.toggle()
    }
}
