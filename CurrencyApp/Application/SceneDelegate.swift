//
//  SceneDelegate.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 22.11.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let mockCurrencies = [
            Currency(code: "RUB", value: 0),
            Currency(code: "USD", value: 1),
            Currency(code: "EUR", value: 2.2),
            Currency(code: "JPY", value: 3),
            Currency(code: "GBP", value: 4),
            Currency(code: "AUD", value: 5.5),
            Currency(code: "CAD", value: 6),
            Currency(code: "CHF", value: 7),
            Currency(code: "CNH", value: 8.8),
            Currency(code: "HKD", value: 9),
            Currency(code: "NZD", value: 10)
        ]
        
        let rootViewController = CurrencyPickerViewController(currencies: mockCurrencies)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

