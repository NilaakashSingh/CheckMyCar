//
//  CarBrandViewModelTests.swift
//  CheckMyCarTests
//
//  Created by Nilaakash Singh on 23/12/21.
//

import XCTest
@testable import CheckMyCar

class CarBrandViewModelTests: XCTestCase {
    
    var viewModel: CarBrandViewModel?

    override func setUp() {
        viewModel = CarBrandViewModel(apiService: MockApiServiceSuccess())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAPISuccess() throws {
        let apiService = MockApiServiceSuccess()
        apiService.mockFileName = "carBrandSample"
        viewModel = CarBrandViewModel(apiService: apiService)
        
        guard let url = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url else {
            XCTFail()
            return
        }
        viewModel?.apiService.get(url: url, type: GenericList.self, completion: { result in
            switch result {
            case .success(let carBrandList):
                XCTAssertEqual(carBrandList.dataDictionary?.count, AppConstant.pageSize)
            case .failure(_):
                XCTFail()
            }
        })
    }
    
    /// Method to test failure case for service layer
    func testFailure() throws {
        viewModel = CarBrandViewModel(apiService: MockApiServiceFailure())
        guard let url = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url else {
            XCTFail()
            return
        }
        viewModel?.apiService.get(url: url, type: GenericList.self, completion: { result in
            switch result {
            case .success(let carBrandList):
                XCTAssertEqual(carBrandList.dataDictionary?.count, AppConstant.pageSize)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, APIError.emptyData.localizedDescription)
            }
        })
    }
    
    /// Method to check wrong url
    func testWrongURL() {
        viewModel = CarBrandViewModel(apiService: MockApiServiceFailure())
        viewModel?.fetchCarBrandList(url: nil)
    }
    
    func testShouldLoadNextPage() {
        if let shouldLoadNextPage = viewModel?.shouldLoadNextPage() {
            XCTAssertTrue(shouldLoadNextPage)
        }
    }
    
    func testShouldLoadNextPageZeroCases() {
        viewModel = CarBrandViewModel(apiService: MockApiServiceFailure())
        if let shouldLoadNextPage = viewModel?.shouldLoadNextPage() {
            XCTAssertFalse(shouldLoadNextPage)
        }
    }
    
    func testHandleDataPaginationTrueCase() {
        let apiService = MockApiServiceSuccess()
        apiService.mockFileName = "carBrandSample"
        viewModel = CarBrandViewModel(apiService: apiService)
        
        guard let url = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url else {
            XCTFail()
            return
        }
        viewModel?.fetchCarBrandList(url: url, paginationApplied: true)
        XCTAssertEqual(viewModel?.carBrandList?.dataDictionary?.count, AppConstant.pageSize)
    }
    
    func testMappedInformationArray() {
        XCTAssertEqual(viewModel?.mappedManufacturerInformationArray(dictionary: ["aa": "aa", "bb" : "bb"]).count, 2)
    }
}
