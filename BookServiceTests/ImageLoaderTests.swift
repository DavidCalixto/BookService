//
//  ImageLoaderTests.swift
//  BookServiceTests
//
//  Created by David Calixto on 28/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
import Combine
class ImageLoaderTest: XCTestCase {
    var sut: InMemoryImageLoader!
    
    override func setUp() {
        sut = InMemoryImageLoader()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testData_givenAnId_retriveData() {
        let id = ""
        sut.data(for: id).sink { data in
            XCTAssertNotNil(data)
        }
        
    }
    func testData_givenAnId_retriveNil() {
        let id = "nil"
        sut.data(for: id).sink { data in
            XCTAssertNil(data)
        }
        
    }
}
protocol ImageLoader: class {
    associatedtype key: Hashable
    func data(for id: key) -> AnyPublisher<Data?, Never >
}
class InMemoryImageLoader: ImageLoader {
    
    func data(for id: String) -> AnyPublisher<Data?, Never > {
        if id == "nil" {
            return Just(nil).eraseToAnyPublisher()
        }
        return Just(Data()).eraseToAnyPublisher()
    }
}
