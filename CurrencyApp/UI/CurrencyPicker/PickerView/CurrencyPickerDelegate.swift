//
//  CurrencyPickerDelegate.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 02.12.2025.
//

protocol CurrencyPickerDelegate: AnyObject {
    
    func didUpdateValue(stringValue: String, picker: CurrencyPickerView)
    func didUpdateCurrency(currency: Currency, picker: CurrencyPickerView)
}
