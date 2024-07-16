//
//  CartProductResponse.swift
//  productUI
//
//  Created by Sena Beyza Ural on 10.07.2024.
//

import Foundation

// MARK: - CartResponse
struct CartResponse: Codable {
    let cart: Cart
    let totalPrice: Double
}

// MARK: - Cart
struct Cart: Codable {
    let id: Int
    let cartProducts: [CartProductResponse]
}

// MARK: - CartProduct
struct CartProductResponse: Codable {
    let id, quantity: Int
    let product: Product
}

