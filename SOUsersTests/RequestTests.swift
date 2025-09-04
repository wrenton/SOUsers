//
//  RequestTests.swift
//  SOUsers
//
//  Created by Renton, William on 04/09/2025.
//

import Testing
import Foundation
@testable import SOUsers

struct RequestTests {
    @Test
    func buildURLRequest_whenValidInput_createsCorrectURL() throws {
        let request = MockRequest(
            baseURL: "https://api.stackexchange.com",
            path: "/2.3/users",
            queryParameters: [
                URLQueryItem(name: "pagesize", value: "20"),
                URLQueryItem(name: "order", value: "desc"),
                URLQueryItem(name: "sort", value: "reputation"),
                URLQueryItem(name: "site", value: "stackoverflow")
            ],
            method: .get
        )

        let urlRequest = try request.buildURLRequest()

        #expect(urlRequest.url?.absoluteString == "https://api.stackexchange.com/2.3/users?pagesize=20&order=desc&sort=reputation&site=stackoverflow")
        #expect(urlRequest.httpMethod == "GET")
    }

    @Test
    func buildURLRequest_withInvalidBaseURL_throwsError() throws {
        let request = MockRequest(
            baseURL: "ht tps://example.com",
            path: "/users",
            queryParameters: nil,
            method: .get
        )

        #expect(throws: URLError(.badURL)) {
            _ = try request.buildURLRequest()
        }
    }
}
