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
        sut = Endpoint("www.google.com")
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

    func testGivenThePath_URL_should_addIt() {
        let path  = "/books/api"
        sut.path = path
        XCTAssertEqual(path, sut.url?.path, "Paths shold be equals")
    }
}

struct Endpoint {
    var url: URL? {
        let url = URL(string: "http://\(host)\(path)")
        
        return url
    }
    let host: String
    var path: String = ""
    init (_ host: String) {
        self.host = host
    }
}
