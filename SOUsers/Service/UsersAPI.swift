//
//  UsersService.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

protocol UsersAPIProtocol {
    func fetchAllUsers() async throws -> [User]
}

struct UsersEndpoint: Request {
    var baseURL: String {
        "https://api.stackexchange.com"
    }
    
    var path: String {
        "/2.3/users"
    }
    
    var queryParameters: [URLQueryItem]? {
        [
            URLQueryItem(name: "pagesize", value: "20"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "sort", value: "reputation"),
            URLQueryItem(name: "site", value: "stackoverflow")
        ]
    }
    
    var method: HTTPMethod {
        .get
    }
}

actor UsersAPI: UsersAPIProtocol {
    private let networking: NetworkingProtocol
    
    init(networking: NetworkingProtocol) {
        self.networking = networking
    }
    
    func fetchAllUsers() async throws -> [User] {
        var usersDTO = try await networking.fetch(from: UsersEndpoint())
        
        return []
    }
}
