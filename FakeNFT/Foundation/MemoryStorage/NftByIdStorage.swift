//
//  NftByIdStorage.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 16.05.2024.
//

import Foundation

protocol NftByIdStorageProtocol: AnyObject {
    var storage: [String: Nft] {get}

    func saveNftById(_ nftById: Nft)
    func getNftById(with id: String) -> Nft?
    func removeNftById(with id: String)
    func removeAllNft()
}

final class NftByIdStorage: NftByIdStorageProtocol {

    var storage: [String: Nft] = [:]

    func saveNftById(_ nftById: Nft) {
        storage[nftById.id] = nftById
    }

    func getNftById(with id: String) -> Nft? {
        storage[id]
    }

    func removeNftById(with id: String) {
        storage[id] = nil
    }

    func removeAllNft() {
        storage = [:]
    }
}
