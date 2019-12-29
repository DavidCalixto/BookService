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

    func testData_givenAnId_retriveNil() {
        let id = "nil"
        sut.data(for: id).sink { data in
            XCTAssertNil(data)
        }
        
    }
    
    func testSave_givenDataAndId_saveData() {
        let id = "notNil"
        let dataFromBytes = Data([0x00, 0x01, 0x02, 0x03])
        sut.save(dataFromBytes, for: id)
        sut.data(for: id).sink { data in
            XCTAssertEqual(dataFromBytes, data)
        }
        
    }
}
protocol ImageLoader: class {
    associatedtype key: Hashable
    func data(for id: key) -> AnyPublisher<Data?, Never >
}
class InMemoryImageLoader: ImageLoader {
    var persistence: [String: Data] = [:]
    func save(_ data: Data, for key: String) {
        persistence[key] = data
    }
    func data(for id: String) -> AnyPublisher<Data?, Never > {
        let data = persistence[id]
        return Just(data).eraseToAnyPublisher()
    }
}
