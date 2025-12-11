//
//  Bindable.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 08.12.2025.
//

class Bindable<T> {
    
    var handlers: [(T) -> Void] = []
    
    var value: T {
        didSet {
            handlers.forEach { handler in
                handler(value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ handler: @escaping (T) -> Void) {
        handlers.append(handler)
        handler(value)
    }
}
