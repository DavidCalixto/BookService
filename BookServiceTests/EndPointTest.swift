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
    
    func assertValidURL(_ url: URL?){
        XCTAssertNotNil(url)
    }
    
    func testEndpoint_has_a_validUrl() {
        assertValidURL(sut.url)
    }
}

struct Endpoint {
    let url: URL?
    
    init (_ url : URL?) {
        self.url = url
    }
}
