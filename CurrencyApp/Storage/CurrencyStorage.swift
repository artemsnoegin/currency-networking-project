//
//  CurrencyStorage.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 24.12.2025.
//

protocol CurrencyStorage {
    
    func saveToTemp(_ currencies: [Currency])
    
    func saveToTemp(_ exchangeRates: [String:Double], of currency: Currency)
    
    func loadCurrenciesFromTemp(allowOutdated: Bool) -> [Currency]?
    
    func loadExchangeRatesFromTemp(for currency: Currency, allowOutdated: Bool) -> [String:Double]?
}
