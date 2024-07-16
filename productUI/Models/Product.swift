//
//  Product.swift
//  productUI
//
//  Created by Sena Beyza Ural on 3.07.2024.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let description: String
    let price: Double
    let stock: Int
    let image: String
}
