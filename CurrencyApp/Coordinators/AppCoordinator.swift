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
        let fileStorage = FileStorage()
        let repository = Repository(networkService: networkService, storage: fileStorage)
        let currencyPickerViewModel = CurrencyPickerViewModel(repository: repository)
        let rootViewController = CurrencyPickerViewController(viewModel:currencyPickerViewModel)

        navigationController.setViewControllers([rootViewController], animated: false)
    }
}
