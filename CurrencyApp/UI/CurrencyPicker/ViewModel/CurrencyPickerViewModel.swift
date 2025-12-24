//
//  CurrencyPickerViewModel.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 08.12.2025.
//

import Foundation

class CurrencyPickerViewModel {
    
    var isLoading: Bindable<Bool> = Bindable(false)
    var currencies: Bindable<[Currency]> = Bindable([])
    var errorMessage: Bindable<String?> = Bindable(nil)
    var convertedString: Bindable<String?> = Bindable(nil)
    
    private var inputAmount: String? = "1"
    
    private var baseCurrency: Currency? = nil
    private var targetCurrency: Currency? = nil
    
    private var exchangeRates = [String: [String: Double]]()
    
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    
    func currentInputAmount() -> String? {
        inputAmount
    }
    
    func updateBaseCurrency(_ currency: Currency) {
        baseCurrency = currency
        
        guard !isLoading.value else { return }

        convertCurrency()
    }
    
    func updateTargetCurrency(_ currency: Currency) {
        targetCurrency = currency
        
        guard !isLoading.value else { return }
        
        convertCurrency()
    }
    
    func updateInputAmount(_ amountString: String) {
        inputAmount = amountString
        
        guard !isLoading.value else { return }
        
        convertCurrency()
    }
    
    func updateCurrencies() {
        isLoading.value = true
        repository.getCurrencies { [weak self] currencies, errorMessage in
            DispatchQueue.main.async {
                self?.errorMessage.value = errorMessage
                
                if let currencies = currencies {
                    self?.currencies.value = currencies
                }
                
                self?.isLoading.value = false
            }
        }
    }
    
    private func convertCurrency() {
        guard let base = baseCurrency,
              let target = targetCurrency,
              let stringAmount = inputAmount,
              let baseAmount = Double(stringAmount)
        else {
            convertedString.value = nil
            return
        }
        
        isLoading.value = true
        
        if let baseRates = exchangeRates[base.code],
           let targetRate = baseRates[target.code] {
            
            convertedString.value = format(baseAmount * targetRate)
            
            isLoading.value = false
        }
        else {
            repository.getExchangeRates(for: base) { [weak self] rates, errorMessage in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.errorMessage.value = errorMessage

                    if let rates {
                        self.exchangeRates[base.code] = rates
                        
                        if let targetRate = rates[target.code] {
                            self.convertedString.value = self.format(baseAmount * targetRate)
                        }
                    } else {
                        self.convertedString.value = nil
                    }
                    
                    self.isLoading.value = false
                }
            }
        }
    }
    
    private func format(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0.0 {
            return String(Int(result))
        } else {
            return String(format: "%.2f", result)
        }
    }
}
