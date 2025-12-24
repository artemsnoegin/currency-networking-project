//
//  CurrencyPickerViewController.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 22.11.2025.
//

import UIKit

class CurrencyPickerViewController: UIViewController {
    
    private let viewModel: CurrencyPickerViewModel
    
    private let leftPickerView = CurrencyPickerView(configuration: BasePickerConfiguration())
    private let rightPickerView = CurrencyPickerView(configuration: TargetPickerConfiguration())
    private let errorView = UIView()
    private var errorViewHeightConstraint: NSLayoutConstraint?
    private let errorLabel = UILabel()
    
    init(viewModel: CurrencyPickerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        viewModel.updateCurrencies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupPickerView()
        setupErrorView()
    }
    
    private func bind() {
        viewModel.currencies.bind { currencies in
            self.leftPickerView.setCurrencies(currencies)
            self.rightPickerView.setCurrencies(currencies)
        }
        viewModel.convertedString.bind { amount in
            self.rightPickerView.setCurrencyAmount(amount)
        }
        viewModel.errorMessage.bind { errorMessage in
            if let errorMessage {
                self.showErrorView(with: errorMessage)
            }
            else {
                self.hideErrorView()
            }
        }
        viewModel.isLoading.bind { loading in
            if loading {
                
            }
            else {
                
            }
        }
    }
    
    private func setupPickerView() {
        leftPickerView.setCurrencyAmount(viewModel.currentInputAmount())
        
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
    
    private func setupErrorView() {
        errorView.backgroundColor = .systemYellow.withAlphaComponent(0.9)
        errorView.layer.shadowRadius = 5
        errorView.layer.shadowOpacity = 0.5
        
        view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.font = .preferredFont(forTextStyle: .headline)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 2
        
        errorView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -16),
            errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -8)
        ])
        errorViewHeightConstraint = errorView.heightAnchor.constraint(equalToConstant: 0)
        errorViewHeightConstraint?.isActive = true
    }
    
    private func showErrorView(with message: String) {
        errorViewHeightConstraint?.constant = view.safeAreaInsets.top
        errorLabel.text = message
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideErrorView() {
        errorViewHeightConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension CurrencyPickerViewController: CurrencyPickerDelegate {
    
    func didChange(amount stringAmount: String, in picker: CurrencyPickerType) {
        guard picker == .base else { return }
        
        viewModel.updateInputAmount(stringAmount)
    }
    
    func didSelectCurrency(_ currency: Currency, in picker: CurrencyPickerType) {
        
        if picker == .base {
            viewModel.updateBaseCurrency(currency)
        }
        else {
            viewModel.updateTargetCurrency(currency)
        }
    }
}
