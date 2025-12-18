//
//  CurrencyPickerViewModel.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 08.12.2025.
//

import Foundation

class CurrencyPickerViewModel {
    
    var currencies: Bindable<[Currency]> = Bindable([])
    var errorMessage: Bindable<String?> = Bindable(nil)
    
    private var baseCurrency: Currency? = nil
    private var targetCurrency: Currency? = nil
    
    private var inputAmount: String? = "1"
    var convertedString: Bindable<String?> = Bindable(nil)
    
    private var exchangeRates = [String: [String: Double]]()
    
    private let networkService: NetworkService
    private let fileManager: UserFileManager

    init(networkService: NetworkService, fileManager: UserFileManager) {
        self.networkService = networkService
        self.fileManager = fileManager
    }
    
    func updateBaseCurrency(_ currency: Currency) {
        baseCurrency = currency
        
        guard let inputAmount = inputAmount,
              let targetCurrency = targetCurrency else { return }
        
        calculateExchangeRate()
    }
    
    func updateTargetCurrency(_ currency: Currency) {
        targetCurrency = currency
        
        guard let inputAmount = inputAmount,
              let baseCurrency = baseCurrency else { return }
        
        calculateExchangeRate()
    }
    
    func updateInputAmount(_ amount: String) {
        inputAmount = amount
        
        guard let baseCurrency = baseCurrency,
              let targetCurrency = targetCurrency else { return }
        
        calculateExchangeRate()
    }
    
    func currentInputAmount() -> String? {
        inputAmount
    }
    
    func getCurrencies() {
        
        if let cashed = fileManager.loadCurrenciesFromTemp() {
            self.currencies.value = cashed
            print("Currencies loaded from cash")
        }
        else {
            networkService.fetchCurrencies { [weak self] result in
                print("Fetching currencies")
                
                switch result {
                case .success(let currencies):
                    let sorted = currencies.sorted { $0.code < $1.code }
                    self?.currencies.value = sorted
                    self?.fileManager.saveToTemp(sorted)
                case .failure(let error):
                    let debugMessage = error.errorDescription ?? NetworkServiceError.undefinedErrorMessage
                    self?.errorMessage.value = error.userMessage
                    print(debugMessage)
                }
            }
        }

        resetErrorMessage()
    }
    
    private func calculateExchangeRate() {
        guard let base = baseCurrency,
              let target = targetCurrency,
              let amountString = inputAmount else {
            convertedString.value = nil
            return
        }
        
        if let baseRates = exchangeRates[base.code],
           let targetRate = baseRates[target.code] {
            convertedString.value = calculateResult(base: amountString, target: targetRate)
        }
        else if let cashed = fileManager.loadExchangeRatesFromTemp(for: base) {
            exchangeRates[base.code] = cashed
            if let targetRate = cashed[target.code] {
                print("Exchange rates for \(base.code) loaded from cash")
                convertedString.value = calculateResult(base: amountString, target: targetRate)
            }
        }
        else {
            networkService.fetchExchangeRates(for: base) { [weak self] result in
                guard let self = self else { return }
                print("Fetching exchange rates for \(base.code)")
                
                switch result {
                case .success(let rates):
                    self.exchangeRates[base.code] = rates
                    self.fileManager.saveToTemp(rates, of: base)
                    
                    if let targetRate = rates[target.code] {
                        self.convertedString.value = self.calculateResult(base: amountString, target: targetRate)
                    }
                case .failure(let error):
                    let debugMessage = error.errorDescription ?? NetworkServiceError.undefinedErrorMessage
                    self.errorMessage.value = error.userMessage
                    self.convertedString.value = nil
                    print(debugMessage)
                }
            }
        }
        resetErrorMessage()
    }
    
    private func calculateResult(base: String, target: Double) -> String? {
        guard !base.isEmpty else {
            return nil
        }
        
        guard let baseValue = Double(base) else {
            errorMessage.value = "Wrong Input"
            print("Wrong input: \(base)")
            return nil
        }
        
        let result = baseValue * target
        
        if result.truncatingRemainder(dividingBy: 1) == 0.0 {
            resetErrorMessage()
            return String(Int(result))
        } else {
            resetErrorMessage()
            return String(format: "%.2f", result)
        }
    }
    
    private func resetErrorMessage() {
        if errorMessage.value != nil {
            errorMessage.value = nil
        }
    }
}
