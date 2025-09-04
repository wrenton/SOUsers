//
//  RequestMock.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation
@testable import SOUsers

struct MockRequest: Request {
    var baseURL: String
    var path: String
    var queryParameters: [URLQueryItem]?
    var method: HTTPMethod
}
