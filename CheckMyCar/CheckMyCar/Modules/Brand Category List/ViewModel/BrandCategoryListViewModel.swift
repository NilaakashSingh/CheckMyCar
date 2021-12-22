//
//  BrandCategoryListViewModel.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 22/12/21.
//

import Combine
import Foundation

// MARK: - Brand List Service Actor
private actor BrandListService {
    
    /// API Service Protocol
    let apiService: APIServiceProtocol
    
    // MARK: - Initialiser
    init(apiService: APIServiceProtocol = WebService()) {
        self.apiService = apiService
    }
    
    /// Method to load brand category list
    func loadBrandCategoryList(url: URL?) async throws -> GenericList? {
        
        guard let url = url else { return nil }
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<GenericList, Error>)  in
            apiService.get(url: url, type: GenericList.self) { result in
                switch result {
                case .success(let brandCategoryList):
                    continuation.resume(returning: brandCategoryList)
                case .failure(let error):
                    continuation.resume(throwing: error)
                    print(error)
                }
            }
        }
    }
}

// MARK: - Brand Category List View Model
class BrandCategoryListViewModel: ObservableObject {
    
    // MARK: - Pubished Variables
    @Published private(set) var brandCategories: [ManufacturerInformation] = []
    @Published private(set) var showLoadingIndicator = false
    
    // MARK: - Variables
    private(set) var manufacturer: ManufacturerInformation
    private(set) var brandCategoryList: GenericList?
    private let brandListService: BrandListService
    
    // MARK: - Initialisers
    init(manufacturer: ManufacturerInformation, apiService: APIServiceProtocol = WebService()) {
        self.manufacturer = manufacturer
        brandListService = BrandListService(apiService: apiService)
    }
    
    // MARK: - User Defined Methods
    /// Method to fetch car brand list
    @MainActor
    func fetchCarBrandList(url: URL? = NetworkLink.brandCategoryListURL(for: "130", page: .zero, pageSize: AppConstant.pageSize).url, paginationEnabled: Bool = false) async throws {
        showLoadingIndicator = true
        defer { showLoadingIndicator = false }
        brandCategoryList = try await brandListService.loadBrandCategoryList(url: url)
        handleData(brandCategorydata: brandCategoryList?.dataDictionary, paginationEnabled: paginationEnabled)
    }
    
    private func handleData(brandCategorydata: [String: String]?, paginationEnabled: Bool) {
        guard let data = brandCategorydata else { return }
        var localManufacturerArray = brandCategories
        if paginationEnabled {
            localManufacturerArray.append(contentsOf: mappedManufacturerInformationArray(dictionary: data))
            brandCategoryList?.page += 1
        } else {
            localManufacturerArray = mappedManufacturerInformationArray(dictionary: data)
            brandCategoryList?.page += 1
        }
        self.brandCategories = localManufacturerArray.unique{ $0.id }
    }
    
    private func mappedManufacturerInformationArray(dictionary: [String: String]) -> [ManufacturerInformation] {
        var manufacturerArray: [ManufacturerInformation] = []
        dictionary.keys.forEach { key in
            manufacturerArray.append(ManufacturerInformation(name: dictionary[key] ?? .empty, id: key))
        }
        return manufacturerArray
    }
    
    func networkLinkURL(manufacturerID: String, page: Int, pageSize: Int) -> URL? {
        return NetworkLink.brandCategoryListURL(for: manufacturerID, page: page, pageSize: pageSize).url
    }
    
    func shouldLoadMoreData() -> Bool {
       return brandCategoryList?.page ?? .zero < brandCategoryList?.totalPageCount ?? .zero && !showLoadingIndicator
    }
}
