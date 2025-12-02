//
//  CurrencyPickerConfiguration.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 22.11.2025.
//

import UIKit

enum CurrencyPickerDirection {
    case leftToRight
    case rightToLeft
}

protocol CurrencyPickerConfiguration {
    
    var pickerColor: UIColor { get set }
    var selectedAttributesColor: UIColor { get set }
    var deselectedAttributesColor: UIColor { get set }
    
    var direction: CurrencyPickerDirection { get set }
    var isBaseCurrencyPicker: Bool { get set }

    var cellHeight: CGFloat { get set }
}


struct LeftCurrencyPickerConfiguration: CurrencyPickerConfiguration {
    
    var pickerColor: UIColor = .darkGray
    var selectedAttributesColor: UIColor = UIColor(red: 255 / 255, green: 155 / 255, blue: 100 / 255, alpha: 1).withAlphaComponent(0.9)
    var deselectedAttributesColor: UIColor = .white.withProminence(.secondary)
    
    var direction: CurrencyPickerDirection = .leftToRight
    var isBaseCurrencyPicker: Bool = true
    
    var cellHeight: CGFloat = 130
}

struct RightCurrencyPickerConfiguration: CurrencyPickerConfiguration {
    
    var pickerColor: UIColor = UIColor(red: 255 / 255, green: 155 / 255, blue: 100 / 255, alpha: 1)
    var selectedAttributesColor: UIColor = .systemRed.withAlphaComponent(0.9)
    var deselectedAttributesColor: UIColor = .black.withProminence(.secondary)
    
    var direction: CurrencyPickerDirection = .rightToLeft
    var isBaseCurrencyPicker: Bool = false
    
    var cellHeight: CGFloat = 130
}

