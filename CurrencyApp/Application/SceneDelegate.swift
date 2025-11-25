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
            Currency(code: "RUB"),
            Currency(code: "USD"),
            Currency(code: "EUR"),
            Currency(code: "JPY"),
            Currency(code: "GBP"),
            Currency(code: "AUD"),
            Currency(code: "CAD"),
            Currency(code: "CHF"),
            Currency(code: "CNH"),
            Currency(code: "HKD"),
            Currency(code: "NZD")
        ]
        
        let rootViewController = CurrencyPickerViewController(currencies: mockCurrencies)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

