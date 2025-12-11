//
//  CurrencyPickerDelegate.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 02.12.2025.
//

protocol CurrencyPickerDelegate: AnyObject {
    
    func didChange(amount stringAmount: String, in picker: CurrencyPickerView)
    func didSelectCurrency(_ currency: Currency, in picker: CurrencyPickerView)
}
