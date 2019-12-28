//
//  EndPointTest.swift
//  BookServiceTests
//
//  Created by David Calixto on 28/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import XCTest
@testable import BookService
class EndPointTest: XCTestCase {

    var sut: Endpoint!
    
    override func setUp() {
        sut = Endpoint("www.googleapis.com")
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func assertValidURL(_ url: URL?){
        XCTAssertNotNil(url)
    }
    
    func assertValidPath(_ path: String) {
        
        XCTAssertEqual(path, sut.url?.path, "Paths shold be equals")
    }
    
    func assertValidQuery(_ queryItems: [String : String]) {
        let query = queryItems.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        XCTAssertEqual(query, sut.url?.query, "Paths shold be equals")
    }
    
    func testEndpoint_has_a_validUrl() {
        assertValidURL(sut.url)
    }

    func testGivenThePath_URL_should_addIt() {
        let path  = "/books/api"
        sut.path = path
        assertValidPath(path)
    }
    
    func testGivenParameters_should_addedAsQuery() {
        let queryItems = ["hola": "Mundo"]
        sut.queryItems = queryItems
        assertValidQuery(queryItems)
    }
    
    func testIntegrationTest() {
       
        sut.path = "/books/v1/volumes"
        sut.queryItems = ["q": "roberto"]
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=roberto"
        XCTAssertEqual(sut.url?.absoluteString, urlString, "Url should contains path and query")
    }
}
