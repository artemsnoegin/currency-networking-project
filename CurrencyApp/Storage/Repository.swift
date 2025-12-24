//
//  Repository.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 24.12.2025.
//

class Repository {
    
    private let networkService: NetworkService
    private let storage: CurrencyStorage
    
    init(networkService: NetworkService, storage: CurrencyStorage) {
        self.networkService = networkService
        self.storage = storage
    }
    
    func getCurrencies(_ completion: @escaping (_ currencies: [Currency]?, _ errorMessage: String?) -> Void) {
        if let cashed = storage.loadCurrenciesFromTemp(allowOutdated: false) {
            print("Cash is up to date")
            completion(cashed, nil)
            print("Loaded currencies from cash")
        }
        else {
            networkService.fetchCurrencies { [weak self] result in
                print("Fetching currencies")
                
                guard let self = self else { return }
                
                switch result {
                case .success(let currencies):
                    let sorted = currencies.sorted { $0.code < $1.code }
                    
                    completion(sorted, nil)
                    self.storage.saveToTemp(sorted)
                    
                case .failure(let error):
                    if let debugMessage = error.errorDescription {
                        print(debugMessage)
                    } else {
                        print(NetworkServiceError.undefinedErrorMessage)
                    }

                    if let cashed = storage.loadCurrenciesFromTemp(allowOutdated: true) {
                        completion(cashed, error.userMessage)
                        print("Currencies loaded from cash and outdated")
                    } else {
                        completion(nil, error.userMessage)
                        print("Currencies were not cashed")
                    }
                }
            }
        }
    }
    
    func getExchangeRates(for base: Currency, completion: @escaping (_ rates: [String:Double]?, _ errorMessage: String?) -> Void) {
        if let cashed = storage.loadExchangeRatesFromTemp(for: base, allowOutdated: false) {
            completion(cashed, nil)
            print("Loaded exchange rates from cash for \(base.code)")
        }
        else {
            networkService.fetchExchangeRates(for: base) { [weak self] result in
                print("Fetching exchange rates for \(base.code)")
                
                guard let self = self else { return }
                
                switch result {
                case .success(let rates):
                    completion(rates, nil)
                    self.storage.saveToTemp(rates, of: base)
                    
                case .failure(let error):
                    if let debugMessage = error.errorDescription {
                        print(debugMessage)
                    }
                    else {
                        print(NetworkServiceError.undefinedErrorMessage)
                    }
                    
                    if let cashed = storage.loadExchangeRatesFromTemp(for: base, allowOutdated: true) {
                        completion(cashed, error.userMessage)
                        print("Exchange rates loaded from cash and outdated")
                    } else {
                        completion(nil, error.userMessage)
                        print("Exchange rates for \(base.code) were not cashed")
                    }
                }
            }
        }
    }
}
