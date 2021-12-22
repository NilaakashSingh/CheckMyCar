//
//  GenericList.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 21/12/21.
//

import Foundation

struct GenericList: Codable {
    
    var page: Int
    let pageSize: Int
    let totalPageCount: Int
    var dataDictionary: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case page, pageSize, totalPageCount
        case dataDictionary = "wkda"
    }
}

struct ManufacturerInformation: Hashable {
    var name: String
    var id: String
}
