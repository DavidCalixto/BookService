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
    var sut: ImageLoader!
    
    override func setUp() {
        sut = ImageLoader()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testData_givenAnId_retriveData() {
        let id = ""
        sut.get(id).sink { data in
            XCTAssertNotNil(data)
        }
        
    }
    func testData_givenAnId_retriveNil() {
        let id = "nil"
        sut.get(id).sink { data in
            XCTAssertNil(data)
        }
        
    }
}

class ImageLoader {
    
    func get(_ id: String) -> AnyPublisher<Data?, Never > {
        if id == "nil" {
            return Just(nil).eraseToAnyPublisher()
        }
        return Just(Data()).eraseToAnyPublisher()
    }
}
