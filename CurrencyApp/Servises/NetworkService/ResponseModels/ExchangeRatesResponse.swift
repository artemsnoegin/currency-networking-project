//
//  ExchangeRatesResponse.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 07.12.2025.
//

struct ExchangeRatesResponse: Decodable {
    let data: [String: Double]
}
