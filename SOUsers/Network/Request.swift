//
//  Request.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

protocol Request {
    var baseURL: String { get }
    var path: String { get }
    var queryParameters: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
}

extension Request {
    func buildURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }

        components.path += path

        if let queryParameters = queryParameters {
            components.queryItems = queryParameters
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
