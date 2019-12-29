//
//  Endpoint.swift
//  BookService
//
//  Created by David Calixto on 28/12/19.
//  Copyright © 2019 David Calixto. All rights reserved.
//

import Foundation
struct Endpoint {
    var url: URL? {
        var urlcomponents = URLComponents()
        urlcomponents.scheme = "https"
        urlcomponents.host = host
        urlcomponents.path = path
        urlcomponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        return urlcomponents.url
    }
    let host: String
    var path: String = ""
    var queryItems: [String : String] = [:]
    init (_ host: String) {
        self.host = host
    }
}
extension Endpoint {
    static func bookSearch(_ query: String) -> URL?{
        var endpoint = Endpoint("www.googleapis.com")
        endpoint.path = "/books/v1/volumes"
        endpoint.queryItems["q"] = query
        return endpoint.url
    }
}

extension Endpoint {
    static func coverImageURL(_ idBook: String) -> URL?{
        var endpoint = Endpoint("books.google.com")
        endpoint.path = "/books/content"
        endpoint.queryItems = [
            "printsec": "frontcover",
            "img": "1",
            "zoom": "5",
            "edge": "curl",
            "source": "gbs_api"]
        endpoint.queryItems["id"] = idBook
        return endpoint.url
    }
}
