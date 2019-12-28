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
        sut = Endpoint(URL(string: "http://www.google.com"))
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testEndpoint_has_a_validUrl() {
        XCTAssertNotNil(sut.url)
    }
}

struct Endpoint {
    var url: URL?
    init (_ url : URL?) {
        self.url = url
    }
}
