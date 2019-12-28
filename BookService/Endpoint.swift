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
