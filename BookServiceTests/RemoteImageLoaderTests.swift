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
        sut = RemoteImageLoader()
    }

    override func tearDown() {
        sut = nil
    }
}

class RemoteImageLoader: ImageLoader {
    
    
    typealias key = String
    
    func data(for id: String) -> AnyPublisher<Data?, Never> {
        return Just(nil).eraseToAnyPublisher()
    }
    
}
