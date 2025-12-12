//
//  Currency.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 24.11.2025.
//

struct Currency: Codable, Equatable {
    
    let symbol: String
    let name: String
    let symbolNative: String
    let decimalDigits: Int
    let rounding: Int
    let code: String
    let namePlural: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case symbolNative = "symbol_native"
        case decimalDigits = "decimal_digits"
        case rounding
        case code
        case namePlural = "name_plural"
        case type
    }
    
    static func ==(lhs: Currency, rhs: Currency) -> Bool {
            return lhs.code == rhs.code
        }
}
