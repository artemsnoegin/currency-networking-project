//
//  Currency.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 24.11.2025.
//

struct Currency: Decodable {
    
    let symbol: String
    let name: String
    let symbol_native: String
    let decimal_digits: Int
    let rounding: Int
    let code: String
    let name_plural: String
    let type: String
}
