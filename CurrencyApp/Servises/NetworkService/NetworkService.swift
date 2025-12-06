//
//  NetworkService.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 03.12.2025.
//

import Foundation

class NetworkService {
    
    private let key = "fca_live_v6rL3B3vrtfhxSaUWRg4KemJioVW4uBzOjz0furr"
    private let urlString = "https://api.freecurrencyapi.com/v1"
    
    func currenciesData(completion: @escaping (Result<Data, NetworkServiceError>) -> Void) {
        let urlString = "\(urlString)/currencies?apikey=\(key)"
        
        requestData(using: urlString) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func latestCurrencyData(for currency: Currency,
                            completion: @escaping (Result<Data, NetworkServiceError>) -> Void) {
        let urlString = "\(urlString)/latest?apikey=\(key)&currencies=&base_currency=\(currency.code)"
        
        requestData(using: urlString) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func latestCurrencyDataForPair(base baseCurrency: Currency,
                                   target targetCurrency: Currency,
                                   completion: @escaping (Result<Data, NetworkServiceError>) -> Void) {
        let urlString = "\(urlString)/latest?apikey=\(key)&currencies=\(targetCurrency.code)&base_currency=\(baseCurrency.code)"
        
        requestData(using: urlString) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func requestData(using urlString: String,
                             completion: @escaping (Result<Data, NetworkServiceError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkServiceError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkServiceError.network(error: error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkServiceError.invalidData))
                return
            }
            completion(.success(data))
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode != 200 else { return }
                
                if let decoded = try? JSONDecoder().decode(ResponseErrorMessage.self, from: data) {
                    completion(.failure(NetworkServiceError.server(
                        message: "\(httpResponse.statusCode) \(decoded.message)")))
                }
                else {
                    completion(.failure(NetworkServiceError.invalidResponseErrorMessage))
                }
            }
            else {
               completion(.failure(NetworkServiceError.invalidResponse))
           }
        }.resume()
    }
}
