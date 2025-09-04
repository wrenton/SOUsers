//
//  Networking.swift
//  SOUsers
//
//  Created by Will Renton on 04/09/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case client(Int)
    case server(Int)
    case unknown(Int)
}

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

protocol NetworkingProtocol {
    func fetch(from request: Request) async throws -> Data
}

struct Networking: NetworkingProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch(from request: any Request) async throws -> Data {
        let request = try request.buildURLRequest()
        
        #if DEBUG
        print("Requesting: \(request.url?.absoluteString ?? "Invalid URL")")
        #endif
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        #if DEBUG
        print("Response Status Code: \(httpResponse.statusCode)")
        #endif

        try checkResponse(httpResponse)

        return data
    }
    
    private func checkResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        // Success!
        case 200...299:
            return
        case 400...499:
            throw NetworkError.client(response.statusCode)
        case 500...599:
            throw NetworkError.server(response.statusCode)
        default:
            throw NetworkError.unknown(response.statusCode)
        }
    }
}
