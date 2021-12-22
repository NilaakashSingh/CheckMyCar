//
//  Constants.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 22/12/21.
//

import Foundation

struct NetworkLink {
    private static let accessToken = "Access Token"
    private static let apiHost = "api-aws-eu-qa-1.xxxx-test.com"
    private static let scheme = "https"
    private static let urlPath = "/v1/car-types/"
    private static let manufacturer = "manufacturer"
    private static let mainType = urlPath + "main-types"
    private static let pageNumber = "page"
    private static let pageSize = "pageSize"
    private static let key = "wa_key"
}

extension NetworkLink {
    static func carBrandListURL(page: Int, pageSize size: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = apiHost
        components.path = "\(urlPath)\(manufacturer)"
        var queryItems = [pageNumber: "\(page)"]
        queryItems[pageSize] = "\(size)"
        queryItems[key] = accessToken
        components.setQueryItems(with: queryItems)
        return components
    }
}

extension NetworkLink {
    static func brandCategoryListURL(for manufactureID: String, page: Int, pageSize size: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = apiHost
        components.path = "\(mainType)"
        var queryItems = [manufacturer: manufactureID]
        queryItems[pageNumber] = "\(page)"
        queryItems[pageSize] = "\(size)"
        queryItems[key] = accessToken
        components.setQueryItems(with: queryItems)
        return components
    }
}
