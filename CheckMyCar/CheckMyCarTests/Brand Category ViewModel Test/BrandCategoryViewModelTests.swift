//
//  BrandCategoryViewModelTests.swift
//  CheckMyCarTests
//
//  Created by Nilaakash Singh on 23/12/21.
//

import XCTest
@testable import CheckMyCar

class BrandCategoryViewModelTests: XCTestCase {

    var viewModel: BrandCategoryListViewModel?
    let manufacturerInformation = ManufacturerInformation(name: "Audi", id: "060")

    override func setUp() {
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturerInformation,
                                               apiService: MockApiServiceSuccess())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAPISuccess() async {
        let apiService = MockApiServiceSuccess()
        apiService.mockFileName = "brandCategorySample"
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturerInformation,
                                               apiService: apiService)
        guard let url = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url else {
            XCTFail()
            return
        }
        
        do {
            let carBrandList = try await viewModel?.brandListService.loadBrandCategoryList(url: url)
            XCTAssertEqual(carBrandList?.dataDictionary?.count, AppConstant.pageSize)
        } catch {
            XCTFail()
        }
    }
    
    /// Method to test failure case for service layer
    func testFailure() async {
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturerInformation,
                                               apiService: MockApiServiceFailure())
        guard let url = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url else {
            XCTFail()
            return
        }
        
        do {
            _ = try await viewModel?.brandListService.loadBrandCategoryList(url: url)
        } catch {
            XCTAssertEqual(error.localizedDescription, APIError.emptyData.localizedDescription)
        }
    }
    
    /// Method to check wrong url
    func testWrongURL() async {
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturerInformation,
                                               apiService: MockApiServiceFailure())
        do {
            _ = try await viewModel?.brandListService.loadBrandCategoryList(url: nil)
        } catch {
            XCTFail()
        }
    }
    
    func testShouldLoadNextPage() {
        if let shouldLoadNextPage = viewModel?.shouldLoadMoreData() {
            XCTAssertFalse(shouldLoadNextPage)
        }
    }
    
    func testShouldLoadNextPageZeroCases() {
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturerInformation,
                                               apiService: MockApiServiceFailure())
        if let shouldLoadNextPage = viewModel?.shouldLoadMoreData() {
            XCTAssertFalse(shouldLoadNextPage)
        }
    }
    
    func testHandleDataPaginationTrueCase() async {
        let apiService = MockApiServiceSuccess()
        apiService.mockFileName = "brandCategorySample"
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturerInformation,
                                               apiService: apiService)
        
        guard let url = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url else {
            XCTFail()
            return
        }
        do {
           try await viewModel?.fetchCarBrandList(url: url, paginationEnabled: true)
        } catch {
            XCTFail()
        }
        XCTAssertEqual(viewModel?.brandCategoryList?.dataDictionary?.count, AppConstant.pageSize)
    }
    
    func testHandleDataPaginationFalseCase() async {
        let apiService = MockApiServiceSuccess()
        apiService.mockFileName = "brandCategorySample"
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturerInformation,
                                               apiService: apiService)
        
        guard let url = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url else {
            XCTFail()
            return
        }
        do {
           try await viewModel?.fetchCarBrandList(url: url, paginationEnabled: false)
        } catch {
            XCTFail()
        }
        XCTAssertEqual(viewModel?.brandCategoryList?.dataDictionary?.count, AppConstant.pageSize)
    }
    
    func testHandleDataPaginationEmptyCase() async {
        let apiService = MockApiServiceSuccess()
        apiService.mockFileName = "brandCategorySample"
        viewModel = BrandCategoryListViewModel(manufacturer: manufacturerInformation,
                                               apiService: apiService)
        do {
           try await viewModel?.fetchCarBrandList(url: nil, paginationEnabled: false)
        } catch {
            XCTFail()
        }
        XCTAssertEqual(viewModel?.brandCategoryList?.dataDictionary?.count ?? .zero, 0)
    }
    
    func testNetworkLinkGeneration() {
        let url1 = viewModel?.networkLinkURL(manufacturerID: manufacturerInformation.id, page: .zero, pageSize: AppConstant.pageSize)
        let url2 = NetworkLink.brandCategoryListURL(for: manufacturerInformation.id, page: .zero, pageSize: AppConstant.pageSize).url
        XCTAssertEqual(url1, url2)
    }
    
    func testMappedInformationArray() {
        XCTAssertEqual(viewModel?.mappedManufacturerInformationArray(dictionary: ["aa": "aa", "bb" : "bb"]).count, 2)
    }
}
