//
//  AppCoordinator.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 08.12.2025.
//

import UIKit

class AppCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let networkService = NetworkService()
        let fileManger = UserFileManager()
        let currencyPickerViewModel = CurrencyPickerViewModel(networkService: networkService,
                                                              fileManager: fileManger)
        let rootViewController = CurrencyPickerViewController(viewModel:currencyPickerViewModel)

        navigationController.setViewControllers([rootViewController], animated: false)
    }
}
