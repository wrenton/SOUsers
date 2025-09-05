//
//  UsersAPI.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

enum UsersAPIError: Error {
    case usersRetrievalError(Error)
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
            URLQueryItem(name: "page", value: "1"),
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

protocol UsersAPIProtocol {
    func fetchAllUsers() async throws -> [User]
}

actor UsersAPI: UsersAPIProtocol {
    private let networking: NetworkingProtocol
    
    init(networking: NetworkingProtocol = Networking()) {
        self.networking = networking
    }
    
    func fetchAllUsers() async throws -> [User] {
        do {
            let data = try await networking.fetch(from: UsersEndpoint())
            let responseDTO = try JSONDecoder().decode(UsersResponseDTO.self, from: data)
            return .from(dto: responseDTO)
        } catch {
            throw UsersAPIError.usersRetrievalError(error)
        }
    }
}
