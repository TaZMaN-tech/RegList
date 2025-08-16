//
//  ProductsService.swift
//  RegList
//
//  Created by Тадевос Курдоглян on 14.08.2025.
//

import Foundation

protocol ProductsServiceProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

final class ProductsService: ProductsServiceProtocol {
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            completion(.failure(NSError(domain: "BadURL", code: -1))); return
        }
        session.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -2))); return
            }
            do {
                let items = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
