//
//  FileStorage.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 12.12.2025.
//

import Foundation

class FileStorage: CurrencyStorage {
    
    private let fileManager = FileManager.default
    private var tempDirectory: URL { fileManager.temporaryDirectory }
    
    func saveToTemp(_ currencies: [Currency]) {
        guard let cashFolderURL = getCashFolder() else { return }
        
        let fileURl = cashFolderURL.appendingPathComponent("Currencies.json")
        saveToFile(currencies, to: fileURl)
    }
    
    func saveToTemp(_ exchangeRates: [String:Double], of currency: Currency) {
        guard let cashFolderURL = getCashFolder() else { return }
        
        let fileURl = cashFolderURL.appendingPathComponent("\(currency.code)_rates.json")
        saveToFile(exchangeRates, to: fileURl)
    }
    
    func loadCurrenciesFromTemp(allowOutdated: Bool) -> [Currency]? {
        guard let cashFolderURL = getCashFolder() else { return nil}
        
        let fileURL = cashFolderURL.appendingPathComponent("Currencies.json")
        return loadContentsOfFile(from: fileURL, allowOutdated: allowOutdated)
    }
    
    func loadExchangeRatesFromTemp(for currency: Currency, allowOutdated: Bool) -> [String:Double]? {
        guard let cashFolderURL = getCashFolder() else { return nil }
        
        let fileURL = cashFolderURL.appendingPathComponent("\(currency.code)_rates.json")
        return loadContentsOfFile(from: fileURL, allowOutdated: allowOutdated)
    }
    
    private func getCashFolder() -> URL? {
        let folderURL = tempDirectory.appendingPathComponent("CurrencyCash")
        
        if fileManager.fileExists(atPath: folderURL.path) {
            return folderURL
        }
        else {
            print("Creating new cash folder")
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
                return folderURL
            } catch {
                print("Error creating cash folder: \(error)")
                return nil
            }
        }
    }
    
    private func saveToFile<T:Codable>(_ codable: T, to fileURL: URL) {
        do {
            let data = try JSONEncoder().encode(codable)
            try data.write(to: fileURL)
        }
        catch {
            print("Error saving to file: \(error.localizedDescription)")
        }
    }
    
    private func loadContentsOfFile<T:Codable>(from fileURL: URL, allowOutdated: Bool) -> T? {
        guard fileManager.fileExists(atPath: fileURL.path)
        else { return nil }
        
        if !allowOutdated {
            guard isUpToDate(contentsOf: fileURL) else { return nil}
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        }
        catch {
            print("Error loading from file: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func isUpToDate(contentsOf fileURL: URL) -> Bool {
        guard fileManager.fileExists(atPath: fileURL.path) else { return false }
        
        let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path)
        
        if let modificationDate = attributes?[.modificationDate] as? Date {
            let interval = Date().timeIntervalSince(modificationDate)
            return interval < 24 * 3600
        }
        else {
            print("Error checking modification date of file")
            return false
        }
    }
}
