//
//  BooksAPITests.swift
//  BookServiceTests
//
//  Created by David Calixto on 30/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
@testable import BookService

class BooksAPITests: XCTestCase {

    var sut: BooksAPI!

    override func setUp() {
        sut = BooksAPI()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testGivenAQuery_should_callRemoteAPI() {
        
        let expectation = XCTestExpectation()
        var cancelables: [AnyCancellable] = []
        let cancellable = sut.searh("reberto").sink(receiveCompletion: { completion in
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
    
    func assertHasImageData(for id: String) {
        let expectation = XCTestExpectation()
        let cancelable = sut.data(for: id).sink { (data) in
            expectation.fulfill()
            XCTAssertTrue(data?.count ?? 0 > 0 )
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGivenAnId_shold_getTheImage(){
        assertHasImageData(for: "h_4j3eVHMkEC")
    }
}

final public class BooksAPI {
    
    public typealias key = String
    public typealias ErrorType = Never
    public typealias PublisherType = AnyPublisher<Data?, ErrorType>
    
    let searcher = BookSearcher()
    let imageLoader = BookImageLoader.make()
}
extension BooksAPI: APICallable {
    
    public func searh(_ query: String) -> AnyPublisher<Data, APIError> {
        return searcher.searh(query)
    }
}

extension BooksAPI: ImageLoader {
    
    public func data(for id: String) -> AnyPublisher<Data?, BooksAPI.ErrorType> {
        return imageLoader.data(for: id)
    }
}


