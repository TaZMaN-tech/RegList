//
//  MainViewModel.swift
//  RegList
//
//  Created by Тадевос Курдоглян on 14.08.2025.
//

import Foundation

final class MainViewModel {
    // Коллбеки с ЯВНЫМИ типами
    var onLoadingChange: ((Bool) -> Void)?
    var onDataChange: (() -> Void)?          // без параметров — просто «данные обновились»
    var onError: ((String) -> Void)?

    private let service: ProductsServiceProtocol
    private(set) var items: [Product] = []

    init(service: ProductsServiceProtocol = ProductsService()) {
        self.service = service
    }

    func load() {
        onLoadingChange?(true)
        service.fetchProducts { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.onLoadingChange?(false)
                switch result {
                case .success(let products):
                    self.items = products
                    self.onDataChange?()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }

    // Утилиты для таблицы
    var count: Int { items.count }
    func title(at index: Int) -> String { items[index].title }
    func priceText(at index: Int) -> String {
        String(format: "%.2f $", items[index].price)
    }
}

// MARK: - Greeting
extension MainViewModel {
    func greetingText() -> String {
        let name = UserDefaults.standard.string(forKey: "userName")?.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName = (name?.isEmpty == false) ? name! : "пользователь"

        let hour = Calendar.current.component(.hour, from: Date())
        let partOfDay: String
        switch hour {
        case 5..<12:  partOfDay = "Доброе утро"
        case 12..<18: partOfDay = "Добрый день"
        case 18..<23: partOfDay = "Добрый вечер"
        default:      partOfDay = "Здравствуйте"
        }

        return "\(partOfDay), \(displayName)!"
    }
}
