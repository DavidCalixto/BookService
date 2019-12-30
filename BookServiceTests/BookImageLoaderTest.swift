//
//  BookImageLoaderTest.swift
//  BookServiceTests
//
//  Created by David Calixto on 29/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
@testable import BookService
class BookImageLoaderTest: XCTestCase {
    var sut: BookImageLoader!
    weak var weakSut: BookImageLoader?
    override func setUp() {
        sut = BookImageLoader.make()
        weakSut = sut
    }
    
    override func tearDown() {
        sut = nil
        XCTAssertNil(weakSut)
    }
    
    func assertHasImageData(for id: String) {
        let expectation = XCTestExpectation()
        let cancelable = sut.data(for: id).sink { (data) in
            expectation.fulfill()
            XCTAssertTrue(data?.count ?? 0 > 0 )
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetRemoteImageData() {
        assertHasImageData(for: "h_4j3eVHMkEC")
    }
    
    func testGetLocalImageDataImageData() {
        assertHasImageData(for: "h_4j3eVHMkEC")
        assertHasImageData(for: "h_4j3eVHMkEC")
    }
}

class BookImageLoader: ImageLoader {
   
    typealias key = String
    typealias ErrorType = Never
    typealias PublisherType = AnyPublisher<Data?, ErrorType>
    
    private let remoteImageLoader: RemoteImageLoader
    private let localImageLoader: InMemoryImageLoader
    
    private enum ImageError: Error {
        case notFound
    }
    
    class func make() -> BookImageLoader {
        return BookImageLoader(RemoteImageLoader(ImageEndpoint("books.google.com")), localImageLoader: InMemoryImageLoader())
    }
    
    init(_ remoteImageLoader: RemoteImageLoader, localImageLoader: InMemoryImageLoader) {
        self.remoteImageLoader = remoteImageLoader
        self.localImageLoader = localImageLoader
    }
    
    
    func data(for id: key) -> PublisherType {
        
        return getLocalOrRemoteData(for: id)
    }
    
    private func getRemoteImage( for id: key) -> PublisherType {
        let cancelable = remoteImageLoader.data(for: id).map {
            self.saveImageData($0.data, for: id)
            return $0.data
        }.catch { (error) -> Just<Data?> in
            return Just<Data?>(nil)
        }
        return cancelable.eraseToAnyPublisher()
    }
    
    private func getLocalOrRemoteData(for id: key) -> PublisherType {
        let cancelable = localImageLoader.data(for: id).flatMap { (data) -> PublisherType in
            if data == nil {  return self.getRemoteImage(for: id) }
            return Just<Data?>(data).eraseToAnyPublisher()
        }
        
        return cancelable.eraseToAnyPublisher()
    }
    private func saveImageData(_ data: Data, for id: key){
        localImageLoader.save(data, for: id)
    }
}
