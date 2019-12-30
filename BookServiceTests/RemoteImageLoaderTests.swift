//
//  RemoteImageLoaderTests.swift
//  BookServiceTests
//
//  Created by David Calixto on 29/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
@testable import BookService
class RemoteImageLoaderTests: XCTestCase {

    var sut: RemoteImageLoader!
    override func setUp() {
        sut = RemoteImageLoader(ImageEndpoint("books.google.com"))
    }

    override func tearDown() {
        sut = nil
    }
    
    func assertHasEndpoint(){
        XCTAssertNotNil(sut.endpoint)
    }
    
    func testCanHandleAnImageEndpoint(){
        assertHasEndpoint()
    }
    
    func test_GetDataFromEndPoint(){
        let expectation =  XCTestExpectation()
    
        var cancelables: [AnyCancellable] = []
        let cancellable = sut.data(for: "h_4j3eVHMkEC").eraseToAnyPublisher()
            .sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                expectation.fulfill()
                break
            case .failure(let error):
                expectation.fulfill()
                XCTFail(error.localizedDescription)
                
            }
            }) { data in
            expectation.fulfill()
            XCTAssertNotNil(data)
            
        }
        cancellable.store(in: &cancelables)
        wait(for: [expectation], timeout: 5)
    }
}

class RemoteImageLoader: ImageLoader {
   

    typealias key = String
    typealias ErrorType = URLError
    typealias PublisherType = URLSession.DataTaskPublisher
    
    var endpoint: Endpoint!
    
    
    init(_ endpoint: Endpoint){
        self.endpoint = endpoint
    }
    
    func data(for id: key) -> PublisherType {
        setBookID(id)
        return getDataTaskPublisher()
    }
    
    private func setBookID(_ id: key){
        endpoint.queryItems["zoom"] = "\(BookCoverSize.small.rawValue)"
        endpoint.queryItems["id"] = id
    }
    
    private func getDataTaskPublisher() -> URLSession.DataTaskPublisher {
        guard let url = endpoint.url else { fatalError("URLs cannot be created")}
        return URLSession.shared.dataTaskPublisher(for: url)
    }
   

}
