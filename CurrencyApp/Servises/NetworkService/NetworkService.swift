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
    
    func fetchCurrencies(completion: @escaping (Result<[Currency], NetworkServiceError>) -> Void) {
        let urlString = "\(urlString)/currencies?apikey=\(key)"
        
        request(using: urlString) { (result: Result<CurrencyResponse, NetworkServiceError>) in
            switch result {
            case .success(let response):
                let currencies = Array(response.data.values)
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchExchangeRates(for currency: Currency,
                            completion: @escaping (Result<[String: Double], NetworkServiceError>) -> Void) {
        let urlString = "\(urlString)/latest?apikey=\(key)&currencies=&base_currency=\(currency.code)"
        
        request(using: urlString) { (result: Result<ExchangeRatesResponse, NetworkServiceError>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func request<T:Decodable>(using urlString: String,
                             completion: @escaping (Result<T, NetworkServiceError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.network(error: error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(error: error)))
            }

            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode != 200 else { return }
                
                if let decoded = try? JSONDecoder().decode(ResponseErrorMessage.self, from: data) {
                    completion(.failure(.server(
                        message: "\(httpResponse.statusCode) \(decoded.message)")))
                }
                else {
                    completion(.failure(.invalidResponseErrorMessage))
                }
            }
            else {
               completion(.failure(.invalidResponse))
           }
        }.resume()
    }
}
