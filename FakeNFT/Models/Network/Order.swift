//
//  OrderDataModel.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 11.05.2024.
//

import Foundation

struct Order: Decodable {
  var nfts: [String]
  var id: String
}
