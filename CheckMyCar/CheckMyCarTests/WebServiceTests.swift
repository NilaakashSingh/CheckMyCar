//
//  WebServiceTests.swift
//  CheckMyCarTests
//
//  Created by Nilaakash Singh on 23/12/21.
//

import XCTest
@testable import CheckMyCar

class WebServiceTests: XCTestCase {
    
    /// Method to test get method
    func testGetMethod() {

        // Given webservice
        let webServiceInstance = WebService()

        // When fetch all news
        let expect = XCTestExpectation(description: "callback")
        
        guard let url = NetworkLink.carBrandListURL(page: .zero, pageSize: AppConstant.pageSize).url else {
            XCTFail()
            return
        }
        webServiceInstance.get(url: url, type: GenericList.self) { result in
            expect.fulfill()
            switch result {
            case .success(let carBrandList):
                XCTAssertEqual(carBrandList.dataDictionary?.keys.count ?? .zero, AppConstant.pageSize)
                carBrandList.dataDictionary?.keys.forEach({ brandName in
                    XCTAssertNotNil(carBrandList.dataDictionary?[brandName])
                })
            case .failure(_):
                // Failure case
                XCTAssertFalse(false)
            }
            self.wait(for: [expect], timeout: 3)
        }
    }
}

// MARK: - MockApiServiceSuccess Class
/// Success Mock class for APIServiceProtocol
class MockApiServiceSuccess: APIServiceProtocol {
    
    var mockFileName: String = .empty
    
    func get<T>(url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        completion(.success(Utility.readLocalFile(forName: mockFileName) as! T))
    }
}

// MARK: - MockApiServiceSuccess Class
/// Failure Mock class for APIServiceProtocol
class MockApiServiceFailure: APIServiceProtocol {
    func get<T>(url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        completion(.failure(APIError.emptyData))
    }
}

class Utility {
    static func readLocalFile(forName name: String) -> GenericList? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json") {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: bundlePath), options: .alwaysMapped)
                let decodedData = try JSONDecoder().decode(GenericList.self, from: jsonData)
                return decodedData
            }
        } catch {
            print(error)
        }
        return nil
    }
}
