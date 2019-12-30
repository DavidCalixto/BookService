//
//  BookSearcherTests.swift
//  BookServiceTests
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
@testable import BookService
class BookSearcherTests: XCTestCase {

    var sut: BookSearcher!
    
    override func setUp() {
        sut = BookSearcher()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testCanHandleAQuery(){
        sut.searh("")
    }
    
    
    
    func testGivenAQuery_should_callRemoteAPI() {
        
        let expectation = XCTestExpectation()
        var cancelables: [AnyCancellable] = []
        let cancellable = sut.searh("roberto").sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
                break
            case .failure(let apiError):
                XCTFail(apiError.localizedDescription)
            }
        }) { (data) in
            expectation.fulfill()
            XCTAssertNotNil(data)
        }
        cancellable.store(in: &cancelables)
        
        wait(for: [expectation], timeout: 5)
    }

}

enum APIError: Error {
    case noService
    case noData
}

class BookSearcher {

    func searh(_ query: String) -> AnyPublisher<Data, APIError> {
        return getRemotePublisher(query)
    }
        func getRemotePublisher(_  query: String) -> AnyPublisher< Data, APIError> {
            guard let url = BookEndpoint.bookSearch(query) else { fatalError("URLs cannot be created") }
            return dataTaskPublisher(url)
        }
            fileprivate func dataTaskPublisher(_ url: URL) -> AnyPublisher< Data, APIError> {
               return URLSession.shared.dataTaskPublisher(for: url)
                .map{ return $0.data }
                .mapError { (error) -> APIError in
                    
                    if error.networkUnavailableReason != nil {
                        return APIError.noService
                    }
                    return APIError.noData
                    }.eraseToAnyPublisher()
            }
}
