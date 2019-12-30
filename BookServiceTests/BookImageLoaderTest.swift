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
        sut = BookImageLoader(remoteImageLoader: RemoteImageLoader(ImageEndpoint("books.google.com")))
        weakSut = sut
    }
    
    override func tearDown() {
        sut = nil
        XCTAssertNil(weakSut)
    }
    
    func assertGetImageData(for id: String) {
        let cancelable = sut.data(for: id).sink { (data) in
            XCTAssertNotNil(data)
        }
    }
    
    func assertHasImageData(for id: String) {
        let cancelable = sut.data(for: id).sink { (data) in
            XCTAssertTrue(data?.count ?? 0 > 0 )
        }
    }
    func testGetImageBookData() {
        assertGetImageData(for: "h_4j3eVHMkEC")
    }
    
    func testGetRemoteImageData() {
        let cancelable = sut.data(for: "h_4j3eVHMkEC").sink { (data) in
            XCTAssertTrue(data?.count ?? 0 > 0 )
        }
    }
    
    func testGetLocalImageDataImageData() {
        assertGetImageData(for: "h_4j3eVHMkEC")
    }
}

class BookImageLoader: ImageLoader {
   
    typealias key = String
    typealias ErrorType = Never
    typealias PublisherType = AnyPublisher<Data?, ErrorType>
    private let remoteImageLoader: RemoteImageLoader
    
    init(remoteImageLoader: RemoteImageLoader) {
        self.remoteImageLoader = remoteImageLoader
    }
    
    
    func data(for id: key) -> PublisherType {
        return getRemoteImage(for: id)
    }
    
    private func getRemoteImage( for id: key) -> PublisherType {
        let cancelable = remoteImageLoader.data(for: id).map {
            return $0.data
        }.catch { (error) -> Just<Data?> in
            return Just<Data?>(nil)
        }
        return cancelable.eraseToAnyPublisher()
    }
    
    
}
