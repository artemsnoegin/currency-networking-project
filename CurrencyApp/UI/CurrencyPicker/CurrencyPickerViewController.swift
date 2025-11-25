//
//  CurrencyPickerViewController.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 22.11.2025.
//

import UIKit

class CurrencyPickerViewController: UIViewController {
    
    private var currencies: [Currency]
    
    private let leftPickerView = CurrencyPickerView(configuration: LeftCurrencyPickerConfiguration())
    private let rightPickerView = CurrencyPickerView(configuration: RightCurrencyPickerConfiguration())
    
    init(currencies: [Currency]) {
        self.currencies = currencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
    }
    
    private func setupPickerView() {

        view.backgroundColor = .white
        
        leftPickerView.currencies = currencies
        rightPickerView.currencies = currencies
        
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
