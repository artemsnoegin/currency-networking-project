//
//  CurrencyPickerViewController.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 22.11.2025.
//

import UIKit

class CurrencyPickerViewController: UIViewController {
    
    private var currencies: [Currency]
    private var baseCurrency: Currency?
    private var targetCurrency: Currency?
    private var value: Double? = 1
    
    private let leftPickerView = CurrencyPickerView(configuration: LeftCurrencyPickerConfiguration())
    private let rightPickerView = CurrencyPickerView(configuration: RightCurrencyPickerConfiguration())
    
    init(currencies: [Currency]) {
        self.currencies = currencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateCurrency() {
        guard let target = targetCurrency else { return }
        guard let value = value else { return }
        
        let result = value * target.value
        
        if result.truncatingRemainder(dividingBy: 1) == 0.0 {
            rightPickerView.updateValue(String(Int(result)))
        }
        else {
            rightPickerView.updateValue(String(result))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
    }
    
    private func setupPickerView() {

        view.backgroundColor = .white
        
        leftPickerView.currencies = currencies
        rightPickerView.currencies = currencies
        
        if let value = value {
            if value.truncatingRemainder(dividingBy: 1) == 0.0 {
                leftPickerView.updateValue(String(Int(value)))
            }
            else {
                leftPickerView.updateValue(String(value))
            }
        }
        else {
            leftPickerView.updateValue(String(0))
        }
        
        leftPickerView.delegate = self
        rightPickerView.delegate = self
        
        [rightPickerView, leftPickerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            leftPickerView.topAnchor.constraint(equalTo: view.topAnchor),
            leftPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftPickerView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            leftPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            rightPickerView.topAnchor.constraint(equalTo: view.topAnchor),
            rightPickerView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            rightPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension CurrencyPickerViewController: CurrencyPickerDelegate {
    
    func didUpdateValue(stringValue: String, picker: CurrencyPickerView) {
        guard picker == leftPickerView else { return }
        
        if stringValue.isEmpty {
            value = 0
        }
        else {
            value = Double(stringValue)
        }
        
        calculateCurrency()
    }
    
    func didUpdateCurrency(currency: Currency, picker: CurrencyPickerView) {
        
        if picker == leftPickerView {
            baseCurrency = currency
        }
        else {
            targetCurrency = currency
        }
        
        calculateCurrency()
    }
}
