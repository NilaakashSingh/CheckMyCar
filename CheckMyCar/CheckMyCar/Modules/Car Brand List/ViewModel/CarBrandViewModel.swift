//
//  CarBrandViewModel.swift
//  CheckMyCar
//
//  Created by Nilaakash Singh on 21/12/21.
//

import Foundation

// MARK: - Car Brand View Model Delegate
protocol CarBrandViewModelDelegate: AnyObject {
    /// Delegate method can be used once list is successfully fetched
    func didFetchListSuccess()
    /// Delegate method to handle failure case
    func didFetchListFailure(error: Error)
}

// MARK: - Car Brand View Model
class CarBrandViewModel {
    
    // MARK: - Variables
    let apiService: APIServiceProtocol
    private(set) var carBrandList: GenericList?
    private(set) var manufacturers: [ManufacturerInformation] = []
    private var isLoading = false
    weak var delegate: CarBrandViewModelDelegate?
    
    // MARK: - Initializer
    /// Intializer
    init(apiService: APIServiceProtocol = WebService()) {
        self.apiService = apiService
    }
}

// MARK: - Extension to fetch car brand data
extension CarBrandViewModel {
    /// Method to fetch car brand data
    func fetchCarBrandList(url: URL? = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url, paginationApplied: Bool = false) {
        
        isLoading = true
        guard let url = url else { return }
        apiService.get(url: url, type: GenericList.self) { [weak self] result in
            switch result {
            case .success(let carBrandList):
                self?.carBrandList = carBrandList
                if let data = carBrandList.dataDictionary,
                   let mappedManufacturerInformationArray = self?.mappedManufacturerInformationArray(dictionary: data) {
                    self?.handleData(manufacturers: mappedManufacturerInformationArray,
                                     paginationApplied: paginationApplied)
                }
                self?.isLoading = false
                self?.delegate?.didFetchListSuccess()
                
            case .failure(let error):
                self?.isLoading = false
                self?.delegate?.didFetchListFailure(error: error)
            }
        }
    }
}

// MARK: - Supporting Methods
extension CarBrandViewModel {
    private func handleData(manufacturers: [ManufacturerInformation], paginationApplied: Bool) {
        if paginationApplied {
            self.manufacturers.append(contentsOf: manufacturers)
            carBrandList?.page += 1
        } else {
            self.manufacturers = manufacturers
            carBrandList?.page += 1
        }
    }
    
    private func mappedManufacturerInformationArray(dictionary: [String: String]) -> [ManufacturerInformation] {
        var manufacturerArray: [ManufacturerInformation] = []
        dictionary.keys.forEach { key in
            manufacturerArray.append(ManufacturerInformation(name: dictionary[key] ?? .empty, id: key))
        }
        return manufacturerArray
    }
    
    func shouldLoadNextPage() -> Bool {
        return !isLoading && carBrandList?.page ?? .zero < carBrandList?.totalPageCount ?? .zero
    }
}
