//
//  CurrencyPickerConfiguration.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 22.11.2025.
//

import UIKit

enum PointerXPosition {
    case center
    case left
    case right
    case custom(value: CGFloat)
}

enum PointerYPosition {
    case center
    case top
    case custom(value: CGFloat)
}

protocol CurrencyPickerConfiguration {
    
    var primaryColor: UIColor { get set }
    var secondaryColor: UIColor { get set }
    
    var pointerHeight: CGFloat { get set }
    var pointerWidth: CGFloat { get set }
    
    var pointerXPosition: PointerXPosition { get set }
    var pointerYPosition: PointerYPosition { get set }
}


struct DefaultCurrencyPickerConfiguration: CurrencyPickerConfiguration {
    
    var primaryColor: UIColor = .systemGray
    var secondaryColor: UIColor = .systemOrange
    
    var pointerHeight: CGFloat = 130
    var pointerWidth: CGFloat = 20
    
    var pointerXPosition: PointerXPosition = .center
    var pointerYPosition: PointerYPosition = .center
}
