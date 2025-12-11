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
    
    var baseCurrency: Bindable<Currency?> = Bindable(nil)
    var targetCurrency: Bindable<Currency?> = Bindable(nil)
    
    var selectedString: Bindable<String?> = Bindable("1")
    var convertedString: Bindable<String?> = Bindable(nil)
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCurrencies() {
        networkService.fetchCurrencies { [weak self] result in
            print("Fetching currencies")
            
            switch result {
            case .success(let currencies):
                self?.currencies.value = currencies.sorted { $0.code < $1.code }
            case .failure(let error):
                let debugMessage = error.errorDescription ?? NetworkServiceError.undefinedErrorMessage
                self?.errorMessage.value = error.userMessage
                print(debugMessage)
            }
        }
        resetErrorMessage()
    }
    
    func calculateExchangeRate() {
        guard let base = baseCurrency.value,
              let target = targetCurrency.value,
              let amountString = selectedString.value else {
            convertedString.value = nil
            print("Currencies are not selected")
            return
        }
        
        if let baseRates = base.exchangeRates,
           let targetRate = baseRates[target.code] {
            convertedString.value = calculateResult(base: amountString, target: targetRate)
        }
        else {
            networkService.fetchExchangeRates(for: base) { [weak self] result in
                guard let self = self else { return }
                print("Fetching exchange rates for \(base.code)")
                
                switch result {
                case .success(let baseRates):
                    if let updatedBase = updateCurrency(base, with: baseRates),
                       let targetRate = updatedBase.exchangeRates?[target.code] {
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

    private func updateCurrency(_ currency: Currency, with rates: [String: Double]) -> Currency? {
        guard let index = currencies.value.firstIndex(where: { $0 == currency }) else {
            print("Could't find index for currency")
            return nil
        }
        
        var updatedCurrency = currencies.value[index]
        updatedCurrency.exchangeRates = rates
        
        var updatedCurrencies = currencies.value
        updatedCurrencies[index] = updatedCurrency
        
        currencies.value = updatedCurrencies
        
        return updatedCurrency
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
