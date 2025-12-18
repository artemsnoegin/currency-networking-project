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

enum CurrencyPickerType {
    case base
    case target
}

protocol CurrencyPickerConfiguration {
    
    var pickerColor: UIColor { get set }
    var selectedAttributesColor: UIColor { get set }
    var deselectedAttributesColor: UIColor { get set }
    
    var direction: CurrencyPickerDirection { get set }
    var pickerType: CurrencyPickerType { get set }

    var cellHeight: CGFloat { get set }
}


struct BasePickerConfiguration: CurrencyPickerConfiguration {
    
    var pickerColor: UIColor = .darkGray
    var selectedAttributesColor: UIColor = UIColor(red: 255 / 255, green: 155 / 255, blue: 100 / 255, alpha: 1).withAlphaComponent(0.9)
    var deselectedAttributesColor: UIColor = .white.withProminence(.secondary)
    
    var direction: CurrencyPickerDirection = .leftToRight
    var pickerType: CurrencyPickerType = .base
    
    var cellHeight: CGFloat = 130
}

struct TargetPickerConfiguration: CurrencyPickerConfiguration {
    
    var pickerColor: UIColor = UIColor(red: 255 / 255, green: 155 / 255, blue: 100 / 255, alpha: 1)
    var selectedAttributesColor: UIColor = .systemRed.withAlphaComponent(0.9)
    var deselectedAttributesColor: UIColor = .black.withProminence(.secondary)
    
    var direction: CurrencyPickerDirection = .rightToLeft
    var pickerType: CurrencyPickerType = .target
    
    var cellHeight: CGFloat = 130
}

