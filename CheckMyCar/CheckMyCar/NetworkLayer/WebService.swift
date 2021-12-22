//
//  WebService.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 21/12/21.
//

import Foundation

enum APIError: String, Error {
    case emptyData = "Empty Data"
}

protocol APIServiceProtocol {
    func get<T: Codable>(url:URL, type: T.Type, completion: @escaping(Result<T, Error>) -> Void)
}

class WebService: APIServiceProtocol {
    func get<T: Codable>(url:URL, type: T.Type,  completion: @escaping(Result<T, Error>) -> Void) {
        // Check internet connection as per your convenience
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = 40
        urlRequest.httpMethod = "GET"
        
        // URL Task to get data
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let apiError = error else {
                do {
                    guard let data = data else {
                        completion(.failure(APIError.emptyData))
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(responseModel))
                } catch {
                    completion(.failure(error))
                }
                return
            }
            completion(.failure(apiError))
        }.resume()
    }
}
