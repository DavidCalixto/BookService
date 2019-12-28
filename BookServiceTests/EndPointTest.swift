//
//  EndPointTest.swift
//  BookServiceTests
//
//  Created by David Calixto on 28/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest

class EndPointTest: XCTestCase {

    var sut: Endpoint!
    
    override func setUp() {
        sut = Endpoint()
    }
    
    override func tearDown() {
        sut = nil
    }
}

struct Endpoint {
    
}
