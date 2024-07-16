//
//  CartProduct.swift
//  productUI
//
//  Created by Sena Beyza Ural on 10.07.2024.
//

import Foundation

struct ProductPayload: Codable {
    let user: Int
    let products: [CartProduct]
}

struct CartProduct: Codable {
    let id: Int
    let quantity: String
}
